terraform {
  backend "s3" {
    bucket = "secure-app-tfstate"
    key    = "mongodb/terraform.tfstate"
    region = "eu-central-1"
  }
}
