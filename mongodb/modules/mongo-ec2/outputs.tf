output "mongo_instance_id" {
  description = "MongoDB EC2 instance ID"
  value       = aws_instance.mongo.id
}

output "mongo_private_ip" {
  description = "MongoDB EC2 private IP"
  value       = aws_instance.mongo.private_ip
}

output "mongo_security_group_id" {
  description = "MongoDB security group ID"
  value       = aws_security_group.mongo.id
}
