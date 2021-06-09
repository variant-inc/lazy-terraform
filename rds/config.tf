terraform {
  required_version = "~> 0.15.0"
  backend local {
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.30"
    }
  }
}
