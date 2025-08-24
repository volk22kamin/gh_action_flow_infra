# needs to be added to match the current state of the project
variable "api_alb_dns_name" {
  description = "DNS name of the API ALB (if applicable)"
  type        = string
  default     = "todo-server-1064291302.eu-central-1.elb.amazonaws.com"
}

variable "acm_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
  default     = "arn:aws:acm:us-east-1:667308168455:certificate/06b03c9f-349d-4a3a-97af-69c1bbb535f7"
}
# until here

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

variable "client_s3_bucket_name" {
  description = "Name of the S3 bucket for the client app"
  type        = string
  default     = "secure-app-client"
}

variable "client_s3_index_document" {
  description = "Index document for the S3 website"
  type        = string
  default     = "index.html"
}

variable "client_s3_server_url" {
  description = "API server URL to inject into index.html"
  type        = string
  default     = "/api"
}

variable "cloudfront_name" {
  description = "Name for the CloudFront distribution"
  type        = string
  default     = "secure-app-cloudfront"
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "production"
    Project     = "secure-app"
    Owner       = "volk"
    ManagedBy   = "Terraform"
  }   
}

