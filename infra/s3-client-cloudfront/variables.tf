variable "api_alb_dns_name" {
  description = "DNS name of the API ALB (if applicable)"
  type        = string
}

variable "acm_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "client_s3_bucket_name" {
  description = "Name of the S3 bucket for the client app"
  type        = string
}

variable "client_s3_index_document" {
  description = "Index document for the S3 website"
  type        = string
}

variable "client_s3_server_url" {
  description = "API server URL to inject into index.html"
  type        = string
}

variable "cloudfront_name" {
  description = "Name for the CloudFront distribution"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
}

