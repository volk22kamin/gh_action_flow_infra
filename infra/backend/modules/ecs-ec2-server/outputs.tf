output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_exec_secrets_policy_arn" {
  description = "ARN of the ECS task execution secrets policy"
  value       = aws_iam_policy.ecs_task_exec_secrets.arn
}

output "ecs_task_exec_secrets_attach_id" {
  description = "ID of the ECS task exec secrets policy attachment"
  value       = aws_iam_role_policy_attachment.ecs_task_exec_secrets_attach.id
}

output "ecs_task_exec_managed_attach_id" {
  description = "ID of the ECS task exec managed policy attachment"
  value       = aws_iam_role_policy_attachment.ecs_task_exec_managed.id
}
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.nodejs_service.name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.ecs_asg.name
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for ECS logs"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}