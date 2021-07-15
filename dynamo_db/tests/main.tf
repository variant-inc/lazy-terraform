terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

provider "aws" {}

module "dynamodb_table" {
  source = "../"

  table_name   = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  octopus_tags = var.octopus_tags

  range_key  = var.range_key
  attributes = var.attributes

  user_tags    = {
    "team": "devops",
    "purpose": "dynamo",
    "owner": "naveen"
  }

  global_secondary_indexes = var.global_secondary_indexes
  local_secondary_indexes  = var.local_secondary_indexes
  read_capacity            = var.read_capacity
  write_capacity           = var.write_capacity
}
