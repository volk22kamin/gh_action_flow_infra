# Create an ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

# Create a Security Group for EC2 instances
resource "aws_security_group" "ecs_sg" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for ECS instances"
  vpc_id      = var.vpc_id

  # Allow all traffic within the VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow dynamic port range from ALB
  ingress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Add IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "${var.cluster_name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ✅ Attach ECS agent permissions
resource "aws_iam_role_policy_attachment" "ecs_ec2_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Add CloudWatch Logs permissions
resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.cluster_name}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

# Create a Launch Template for EC2 instances
resource "aws_launch_template" "ecs_lt" {
  name          = "${var.cluster_name}-lt"
  instance_type = var.instance_type
  key_name      = var.key_name

  image_id = data.aws_ami.ecs_optimized.id

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.this.name} > /etc/ecs/ecs.config
echo ECS_ENABLE_TASK_IAM_ROLE=true >> /etc/ecs/ecs.config
EOF
  )

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ecs_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
    }
  }
}

# Create an Auto Scaling Group for EC2 instances
resource "aws_autoscaling_group" "ecs_asg" {
  name = "${var.cluster_name}-asg"
  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  vpc_zone_identifier = var.private_subnet_ids

  # Scale based on EC2 CPU utilization
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-ecs-instance"
    propagate_at_launch = true
  }
}

# Create CloudWatch Log Group for ECS logs
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.cluster_name}-ecs-logs"
  }
}

# For the secret pull
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.cluster_name}-ecs-task-execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Principal= { Service = "ecs-tasks.amazonaws.com" },
      Action   = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_managed" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_task_exec_secrets" {
  name   = "${var.cluster_name}-ecs-task-exec-secrets"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid      : "GetMongoSecret",
      Effect   : "Allow",
      Action   : ["secretsmanager:GetSecretValue"],
      Resource : var.mongodb_secret_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_secrets_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_exec_secrets.arn
}


# Create an ECS Task Definition for the Node.js container
resource "aws_ecs_task_definition" "nodejs_task" {
  family                   = "${var.cluster_name}-task"
  network_mode             = "bridge"  # Changed from "awsvpc" to "bridge" for dynamic port mapping
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  
  container_definitions = jsonencode([
    {
      name      = "nodejs-container"
      image     = var.container_image
      cpu       = var.task_cpu
      memory    = var.task_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = 0  # Dynamic port mapping
          protocol      = "tcp"
        }
      ]

      secrets = [
        {
          name      = "MONGO_PASSWORD"
          valueFrom = "${var.mongodb_secret_arn}:password::"
        }
      ]
      environment = [
        {
          name  = "MONGO_HOST"
          value = var.mongo_host
        },
        {
          name  = "MONGO_DB"
          value = var.mongo_db
        },
        {
          name  = "MONGO_USER"
          value = var.mongo_user
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "nodejs-container"
        }
      }
    }
  ])
}

# Create an ECS Service to manage the Node.js container
resource "aws_ecs_service" "nodejs_service" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.nodejs_task.arn
  desired_count   = 0
  launch_type     = "EC2"

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 30

  # Load balancer configuration (conditional)
  dynamic "load_balancer" {
    for_each = var.target_group_arn != "" ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = "nodejs-container"
      container_port   = var.container_port
    }
  }

  # Enable ECS Service Auto Scaling
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

# ECS Service Auto Scaling
resource "aws_appautoscaling_target" "ecs_scaling_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.nodejs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.service_min_count
  max_capacity       = var.service_max_count
}

resource "aws_appautoscaling_policy" "ecs_scaling_policy" {
  name               = "${var.cluster_name}-scaling-policy"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.service_cpu_target
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}