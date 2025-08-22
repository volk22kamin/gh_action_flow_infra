variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "container_port" {
  description = "Port on which the container is listening"
  type        = number
}

variable "ecs_security_group_id" {
  description = "Security group ID of the ECS service"
  type        = string
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/"
}