
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

# Aliases are required because of cross-region
provider "aws" {
  alias   = "this"
  profile = var.vpc_src_profile
  region  = var.vpc_src_region
}

provider "aws" {
  alias   = "peer"
  profile = var.vpc_dest_profile
  region  = var.vpc_dest_region
}
