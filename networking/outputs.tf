output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = module.vpc.private_route_table_id
}

output "vpc_endpoint_ids" {
  description = "IDs of the created VPC endpoints"
  value       = module.vpc_endpoints.vpc_endpoint_ids
}

output "vpc_endpoint_arns" {
  description = "ARNs of the created VPC endpoints"
  value       = module.vpc_endpoints.vpc_endpoint_arns
}

output "flow_log_id" {
  description = "The ID of the VPC Flow Log"
  value       = module.vpc_flow_logs.flow_log_id
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = module.vpc_flow_logs.cloudwatch_log_group_name
}

output "public_nacl_id" {
  description = "The ID of the public network ACL"
  value       = module.nacl.public_nacl_id
}

output "endpoints_sg_id" {
  description = "The ID of the endpoints security group"
  value       = module.endpoints_sg.ecs_sg_id
}