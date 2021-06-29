terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

variable "env" {
}

module "rds" {
  source = "../"

  identifier = "test"
  user_tags = {
    team    = "devops"
    purpose = "elk module test"
    owner   = "Samir"
  }
  name              = "test"
  env               = var.env
  storage_type      = "gp2"
  apply_immediately = true
  octopus_tags      = { project = "project_name", space = "space_name" }
}
