output "ecs_to_mongo_sg_id" {
  description = "The ID of the ECS to MongoDB security group."
  value       = module.ecs_to_mongo_sg.security_group_id
}
