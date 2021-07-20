terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

provider "aws" {}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "lazy_api_host" {
  type = string
}

variable "lazy_api_key" {
  type      = string
  sensitive = true
}

variable "aws_role_to_assume" {
  type = string
}

variable "region" {
  type = string
}

module "test_s3_module" {
  source = "../"

  region = var.region

  lazy_api_key  = var.lazy_api_key
  lazy_api_host = var.lazy_api_host

  bucket_prefix = "test-123asdasdas"
  role_arn      = var.aws_role_to_assume

  env = "non-prod"

  octopus_tags = var.octopus_tags
  user_tags = {
    team    = "devops2"
    purpose = "s3-test3"
    owner   = "naveen3"
  }
}
