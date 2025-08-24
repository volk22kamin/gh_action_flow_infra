terraform {
  backend "s3" {
    bucket = "secure-app-tfstate"
    key    = "backend/terraform.tfstate"
    region = "eu-central-1"
  }
}
