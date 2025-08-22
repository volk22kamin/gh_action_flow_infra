variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
  default     = "vpc-0bbc6afe7a8d32c90"
}

variable "mongodb_uri" {
  description = "MongoDB connection URI"
  type        = string
  default     = "mongodb://admin:volk_password@10.0.2.152:27017/todo"
}

variable "container_image" {
  description = "Docker image for the Node.js container"
  type        = string
  default     = "667308168455.dkr.ecr.eu-central-1.amazonaws.com/secure-app-backend:75ef53f12813"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0083ee179c14acc6a"  
}
variable "region" {
  description = "The AWS region to deploy the application"
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "dev-cluster"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
  default     = "ec2-from-local"
}

variable "volume_size" {
  description = "Root volume size for EC2 instances"
  type        = number
  default     = 30
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

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 1
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "todo-server"
}

variable "health_check_path" {
  description = "Path for ALB health check"
  type        = string
  default     = "/"
}