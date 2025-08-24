terraform {
  backend "s3" {
    bucket = "secure-app-tfstate"
    key    = "route53/terraform.tfstate"
    region = "eu-central-1"
  }
}
