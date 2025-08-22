resource "aws_flow_log" "this" {
  log_destination      = aws_cloudwatch_log_group.this.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = var.traffic_type
  vpc_id               = var.vpc_id
  iam_role_arn         = aws_iam_role.flow_logs.arn
  tags                 = var.tags
}

# IAM Role for Flow Logs to publish to CloudWatch Logs
resource "aws_iam_role" "flow_logs" {
  name = "${var.name}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  name   = "${var.name}-flow-logs-policy"
  role   = aws_iam_role.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      Resource = "*"
    }]
  })
}

# CloudWatch Log Group with retention
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/vpc/flow-logs/${var.name}"
  retention_in_days = var.cloudwatch_retention_in_days

  tags = var.tags
}

resource "null_resource" "purge_log_streams" {
  triggers = {
    log_group_name = aws_cloudwatch_log_group.this.name
  }

  provisioner "local-exec" {
    when    = destroy
    command = "streams=$(aws logs describe-log-streams --log-group-name ${self.triggers.log_group_name} --query 'logStreams[].logStreamName' --output text) && [ -n \"$streams\" ] && echo \"$streams\" | xargs -n1 -I {} aws logs delete-log-stream --log-group-name ${self.triggers.log_group_name} --log-stream-name {} || echo 'No log streams found in ${self.triggers.log_group_name}'"
  }

  # depends_on = [aws_flow_log.this]
}
