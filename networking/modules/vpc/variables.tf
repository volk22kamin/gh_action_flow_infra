variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS support for the VPC"
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
}

variable "name" {
  description = "The name of the VPC"
  type        = string
}

variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
  default     = 2
}
