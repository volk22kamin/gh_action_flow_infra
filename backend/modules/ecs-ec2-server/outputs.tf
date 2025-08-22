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

output "security_group_id" {
  description = "ID of the security group for ECS instances"
  value       = aws_security_group.ecs_sg.id
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for ECS logs"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}