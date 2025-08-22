variable "public_subnet_count" {
  description = "Number of public subnets to create in the VPC"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets to create in the VPC"
  type        = number
  default     = 2
}

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_endpoints" {
  description = "List of VPC endpoints to create"
  type        = list(object({
    service_name = string
    route_table_ids = list(string)
  }))
  default     = [
    {
      service_name   = "com.amazonaws.eu-central-1.s3"
      route_table_ids = []
    },
    {
      service_name   = "com.amazonaws.eu-central-1.dynamodb"
      route_table_ids = []
    }
  ]
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {   
    "Environment" = "dev",
    "Project"     = "secure-app",
    "ManagedBy"   = "Terraform"
  }
}