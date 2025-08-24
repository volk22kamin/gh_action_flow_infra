terraform {
  backend "s3" {
    bucket = "secure-app-tfstate"
    key    = "networking/terraform.tfstate"
    region = "eu-central-1"
  }
}
