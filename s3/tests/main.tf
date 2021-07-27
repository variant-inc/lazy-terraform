terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

provider "aws" {}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "region" {
  type = string
  default = "us-east-1"
}

module "test_s3_module" {
  source = "../"

  region = var.region

  bucket_prefix      = "test-123asdasdas"

  env = "non-prod"

  octopus_tags = var.octopus_tags
  user_tags = {
    team    = "devops2"
    purpose = "s3-test3"
    owner   = "naveen3"
  }
}

output "result" {
  value = module.test_s3_module
}
