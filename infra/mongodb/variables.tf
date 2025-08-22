# needs to be updated to match the current state of the project
variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
  default     = "vpc-0fcd1864ebf95b4eb"
}

variable "mongo_ami_id" {
  description = "AMI ID for MongoDB SSM EC2 instance, custom made"
  type        = string
  default     = "ami-09fae3716248c503d"
}

# taken from module 'backend' after creation
# variable "ecs_service_sg_id" {
#   description = "Security group ID for the ECS service"
#   type        = list(string)
#   default     = []
# }
# until here

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

