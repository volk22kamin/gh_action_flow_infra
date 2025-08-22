variable "primary_domain" {
  description = "Primary domain for ACM certificate (e.g. api.volk.baby)"
  type        = string
}

variable "san_domains" {
  description = "Subject alternative names for ACM certificate (e.g. app.volk.baby)"
  type        = list(string)
  default     = []
}

variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID for DNS validation"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name for CNAME record"
  type        = string
}

variable "domain_name" {
  description = "The root domain for the hosted zone (e.g. volk.baby)"
  type        = string
  default     = ""
}