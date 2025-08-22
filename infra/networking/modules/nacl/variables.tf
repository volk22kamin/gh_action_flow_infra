variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to associate with the NACL"
  type        = list(string)
}

variable "default_tags" {
  description = "Default tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets for dynamic ingress rules"
  type        = list(string)
  default     = []
}