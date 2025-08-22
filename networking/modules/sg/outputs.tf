output "alb_sg_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ecs_sg_id" {
  description = "The ID of the ECS security group"
  value       = aws_security_group.ecs.id
}

output "mongodb_sg_id" {
  description = "The ID of the MongoDB security group"
  value       = aws_security_group.mongodb.id
}