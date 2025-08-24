variable "domain_name" {
  description = "The root domain for the hosted zone (e.g. volk.baby)"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the application"
}