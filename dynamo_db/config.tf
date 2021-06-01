
provider "aws" {
    profile = var.profile
}
terraform {
  backend "s3" {
  }
}