variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 1
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}

variable "volume_size" {
  description = "Root volume size for EC2 instances"
  type        = number
  default     = 20
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory (in MiB) for the ECS task"
  type        = number
  default     = 512
}

variable "container_image" {
  description = "Docker image for the Node.js container"
  type        = string
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 3000
}

variable "service_desired_count" {
  description = "Desired number of containers in the ECS service"
  type        = number
  default     = 1
}

variable "service_min_count" {
  description = "Minimum number of containers in the ECS service"
  type        = number
  default     = 1
}

variable "service_max_count" {
  description = "Maximum number of containers in the ECS service"
  type        = number
  default     = 3
}

variable "service_cpu_target" {
  description = "Target CPU utilization for ECS service auto scaling"
  type        = number
  default     = 70
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "mongo_host" {
  description = "MongoDB host address"
  type        = string
}

variable "mongo_db" {
  description = "MongoDB database name"
  type        = string
}

variable "mongo_user" {
  description = "MongoDB username"
  type        = string
}

variable "mongodb_secret_arn" {
  description = "mongodb_secret_arn"
  type = string
}