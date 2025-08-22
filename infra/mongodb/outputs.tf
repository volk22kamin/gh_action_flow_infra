output "mongo_instance_id" {
  description = "MongoDB EC2 instance ID"
  value       = module.mongo_ec2.mongo_instance_id
}

output "mongo_private_ip" {
  description = "MongoDB EC2 private IP"
  value       = module.mongo_ec2.mongo_private_ip
}

output "mongo_security_group_id" {
  description = "MongoDB security group ID"
  value       = module.mongo_ec2.mongo_security_group_id
}
