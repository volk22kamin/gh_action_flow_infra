variable "public_subnet_count" {
  description = "Number of public subnets to create in the VPC"
  type        = number
}

variable "private_subnet_count" {
  description = "Number of private subnets to create in the VPC"
  type        = number
}

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "vpc_endpoints" {
  description = "List of VPC endpoints to create"
  type        = list(object({
    service_name = string
    route_table_ids = list(string)
  }))
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
}