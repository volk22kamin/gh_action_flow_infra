variable "server_port" {
  description = "The port on which the server listens"
  type        = number
  default     = 3000
}
variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}