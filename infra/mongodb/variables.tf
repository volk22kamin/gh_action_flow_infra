variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "mongo_ami_id" {
  description = "AMI ID for MongoDB SSM EC2 instance, custom made"
  type        = string
}

variable "ecs_service_sg_id" {
  description = "Security group ID for the ECS service"
  type        = list(string)
}

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

