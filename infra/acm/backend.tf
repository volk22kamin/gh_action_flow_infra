terraform {
  backend "s3" {
    bucket = "secure-app-tfstate"
    key    = "acm/terraform.tfstate"
    region = "eu-central-1"
  }
}
