# needs to be updated to match the current state of the project
# taken from route53 module
variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID for DNS validation"
  type        = string
}

# taken from cloudfront module
variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name for CNAME record"
  type        = string
}
# until here

variable "domain_name" {
  description = "The root domain for the hosted zone (e.g. volk.baby)"
  type        = string
}
