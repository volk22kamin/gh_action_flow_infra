# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.alb_name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  # Allow HTTP inbound from internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS inbound from internet (for future use)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound to ECS containers on dynamic ports
  egress {
    from_port       = 32768
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  # Allow outbound for health checks
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.alb_name}-alb-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets           = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

# Target Group for ECS Service
resource "aws_lb_target_group" "ecs_targets" {
  name        = "${var.alb_name}-tg"
  port        = 80  # This will be overridden by ECS for dynamic port mapping
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = var.health_check_path
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    # Don't specify port here - let ECS handle dynamic port registration
  }

  tags = {
    Name = "${var.alb_name}-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_targets.arn
  }
}