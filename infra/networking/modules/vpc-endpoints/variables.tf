variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "route_table_ids" {
  description = "List of route table IDs"
  type        = list(string)
}

variable "vpc_endpoints" {
  description = "List of VPC endpoints to create"
  type = list(object({
    service_name        = string
    type                = string
    tags                = map(string)
    private_dns_enabled = optional(bool)
    route_table_ids     = optional(list(string))
  }))
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
}