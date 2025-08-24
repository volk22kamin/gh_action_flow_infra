output "security_group_id" {
  description = "ID of the security group for ECS to mongo instance"
  value       = aws_security_group.ecs_to_mongo_sg.id
}
