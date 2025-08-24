output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role"
  value       = module.ecs_ec2_server.ecs_task_execution_role_arn
}

output "ecs_task_exec_secrets_policy_arn" {
  description = "ARN of the ECS task execution secrets policy"
  value       = module.ecs_ec2_server.ecs_task_exec_secrets_policy_arn
}

output "ecs_task_exec_secrets_attach_id" {
  description = "ID of the ECS task exec secrets policy attachment"
  value       = module.ecs_ec2_server.ecs_task_exec_secrets_attach_id
}

output "ecs_task_exec_managed_attach_id" {
  description = "ID of the ECS task exec managed policy attachment"
  value       = module.ecs_ec2_server.ecs_task_exec_managed_attach_id
}
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs_ec2_server.ecs_cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.ecs_ec2_server.ecs_service_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.ecs_ec2_server.asg_name
}


output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for ECS logs"
  value       = module.ecs_ec2_server.cloudwatch_log_group_name
}

# ALB Outputs
output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.ecs_api_alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = module.ecs_api_alb.alb_zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.ecs_api_alb.target_group_arn
}