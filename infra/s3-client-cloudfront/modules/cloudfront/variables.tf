variable "name" {
  description = "Name for the CloudFront distribution"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket origin"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to CloudFront resources"
  type        = map(string)
  default     = {}
}

variable "api_alb_dns_name" {
  description = "DNS name of the API ALB (if applicable)"
  type        = string
  default     = ""
}

variable "acm_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
}