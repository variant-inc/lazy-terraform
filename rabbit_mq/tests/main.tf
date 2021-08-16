terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

provider "aws" {}

module "rabbit_mq" {
  source = "../"

  broker_name         = var.broker_name
  publicly_accessible = var.publicly_accessible
  
  user_tags           = var.user_tags
  octopus_tags        = var.octopus_tags
}