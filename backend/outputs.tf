
output "ecs_cluster_name" {
	value = module.ecs_ec2_server.ecs_cluster_name
}

output "ecs_cluster_arn" {
	value = module.ecs_ec2_server.ecs_cluster_arn
}

output "task_execution_role_arn" {
	value = module.ecs_ec2_server.task_execution_role_arn
}

output "log_group_name" {
	value = module.ecs_ec2_server.log_group_name
}
