
variable "cluster_name" {
	description = "Name of the ECS cluster."
	type        = string
	default     = "dev-cluster"
}

variable "enable_container_insights" {
	description = "Enable Container Insights for ECS cluster."
	type        = bool
	default     = false
}

variable "log_retention_days" {
	description = "Number of days to retain logs in CloudWatch Log Group."
	type        = number
	default     = 1
}
