output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.this.arn
}

output "task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}
