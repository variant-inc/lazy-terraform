
provider "aws" {
    region     = var.region
    profile = var.profile
}
terraform {
  required_version = "~> 0.14.0"
    backend s3 {
  }
}