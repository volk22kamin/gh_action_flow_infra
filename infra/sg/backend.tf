terraform {
  backend "s3" {
    bucket = "secure-app-tfstate"
    key    = "sg/terraform.tfstate"
    region = "eu-central-1"
  }
}
