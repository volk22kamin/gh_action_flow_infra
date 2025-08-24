terraform {
  backend "s3" {
    bucket = "secure-app-tfstate"
    key    = "gh_oidc/terraform.tfstate"
    region = "eu-central-1"
  }
}
