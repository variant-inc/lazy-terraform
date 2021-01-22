provider "aws" {
    region     = var.zone
    profile = var.profile
}

terraform {
  required_version = "~> 0.14.0"
}





