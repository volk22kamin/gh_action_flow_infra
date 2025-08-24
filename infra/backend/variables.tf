variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
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
  type        = string
}

variable "container_image" {
  description = "Docker image for the Node.js container"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "ecs_sg_id" {
  description = "security group for ecs to mongo"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the application"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}

variable "volume_size" {
  description = "Root volume size for EC2 instances"
  type        = number
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
}

variable "task_memory" {
  description = "Memory (in MiB) for the ECS task"
  type        = number
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
}

variable "service_desired_count" {
  description = "Desired number of containers in the ECS service"
  type        = number
}

variable "service_min_count" {
  description = "Minimum number of containers in the ECS service"
  type        = number
}

variable "service_max_count" {
  description = "Maximum number of containers in the ECS service"
  type        = number
}

variable "service_cpu_target" {
  description = "Target CPU utilization for ECS service auto scaling"
  type        = number
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "health_check_path" {
  description = "Path for ALB health check"
  type        = string
}