terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

variable "env" {
}
variable "domain" {
  type = string
}

module "rds" {
  source = "../"

  identifier = "test-ops"
  user_tags = {
    team    = "devops"
    purpose = "elk module test"
    owner   = "Samir"
  }
  cluster_name      = "variant-ops"
  name              = "test"
  domain            = var.domain
  env               = var.env
  storage_type      = "gp2"
  apply_immediately = true
  octopus_tags      = { project = "project_name", space = "space_name" }
}
