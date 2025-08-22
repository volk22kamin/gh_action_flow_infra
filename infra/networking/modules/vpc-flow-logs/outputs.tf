output "flow_log_id" {
  description = "The ID of the VPC Flow Log"
  value       = aws_flow_log.this.id
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.this.name
}

output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.this.arn
}

output "iam_role_arn" {
  description = "The ARN of the IAM role used for Flow Logs"
  value       = aws_iam_role.flow_logs.arn
}