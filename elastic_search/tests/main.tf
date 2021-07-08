terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

provider "aws" {}

variable "domain" {
  type = string
}

variable "octopus_tags" {
  type = map(string)
}

module "module-test" {
  source = "../"

  domain_name  = "test"
  cluster_name = "variant-ops"

  cluster_config = {
    dedicated_master_enabled = false
    instance_count           = 1
  }
  master_user_options = {
    master_user_name = "devops-test-user"
  }

  user_tags = {
    team    = "devops"
    purpose = "elk module test"
    owner   = "Samir"
  }
  domain       = var.domain
  octopus_tags = var.octopus_tags # If run from octopus, this will be auto populated
}
