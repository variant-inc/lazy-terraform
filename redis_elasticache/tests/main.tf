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

module "cache_cluster" {
  source = "../"

  domain_name  = "test-m"
  cluster_name = "variant-ops"
  domain       = var.domain

  user_tags = {
    team    = "devops"
    purpose = "elk module test"
    owner   = "Samir"
  }
  octopus_tags = var.octopus_tags # If run from octopus, this will be auto populated
}

output "cluster" {
  value = module.cache_cluster
}
