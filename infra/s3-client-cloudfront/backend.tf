terraform {
  backend "s3" {
    bucket = "secure-app-tfstate"
    key    = "client-cloudfront/terraform.tfstate"
    region = "eu-central-1"
  }
}
