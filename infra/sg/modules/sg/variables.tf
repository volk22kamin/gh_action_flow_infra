variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "cluster_name" {
  description = "cluster_name to where sg is connected"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}