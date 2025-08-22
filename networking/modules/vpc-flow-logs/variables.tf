variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to enable flow logs for"
  type        = string
}

variable "traffic_type" {
  description = "The type of traffic to log (ACCEPT, REJECT, ALL)"
  type        = string
  default     = "ALL"
}

variable "cloudwatch_retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}