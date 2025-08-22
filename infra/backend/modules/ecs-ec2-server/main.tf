# ECS Cluster (control plane only)
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  # Turn on only if you want Container Insights (generates CW metrics charges)
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = {
    Name = var.cluster_name
  }
}

# Optional: App log group your future tasks can use
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = var.log_retention_days
}

# Task Execution Role (used by future task definitions)
# Works for both EC2 launch-type and Fargate tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.cluster_name}-ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action   = "sts:AssumeRole"
    }]
  })
}

# Grants pulling from ECR, pushing logs, etc.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_managed" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# (Optional) If you plan to load secrets via task definition envFrom/secrets
# attach read-only Secrets Manager access later or per-need:
# resource "aws_iam_policy_attachment" "secrets_ro" { ... }

