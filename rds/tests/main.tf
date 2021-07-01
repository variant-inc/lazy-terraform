terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

provider "aws" {}
provider "aws" {
  alias  = "replica"
  region = "us-east-2"
}

variable "assume_role_arn" {
  default = null
}
variable "env" {
}
variable "domain" {
  type = string
}
variable "octopus_tags" {
  type = map(string)
}

module "rds" {
  source = "../"

  providers = {
    aws.replica = aws.replica
  }

  identifier = "test-ops"
  user_tags = {
    team    = "cloudops"
    purpose = "rds module test"
    owner   = "cloudops"
  }
  cluster_name      = "variant-ops"
  name              = "test"
  domain            = var.domain
  env               = var.env
  storage_type      = "gp2"
  apply_immediately = true
  octopus_tags      = var.octopus_tags
}
