variable "mongo_ami_id" {
  description = "AMI ID for MongoDB EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for EC2 instance"
  type        = string
}

variable "ecs_service_sg_id" {
  description = "List of ECS service security group IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
