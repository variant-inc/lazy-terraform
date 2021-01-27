terraform {
  backend "s3" {
    profile         = "iaac_ops"
    bucket          = ""
    key             = "vpc/default"
    region          = "us-west-2"
    dynamodb_table  = "lazy_tf_state"
    encrypt         = true
    kms_key_id      = ""
  }
}

resource "random_id" "random_id_prefix" {
  byte_length = 2
}

locals {
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c", "${var.region}d"]
  vpc_name = "default"
}

module "networking" {
  source = "./modules/networking"

  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = local.availability_zones
  vpc_name             = local.vpc_name
}