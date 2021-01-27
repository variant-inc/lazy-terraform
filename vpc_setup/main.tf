terraform {
  backend "s3" {
    profile         = "iaac_ops"
    bucket          = "lazy-tf-state20210107203535113800000001"
    key             = "vpc/default"
    region          = "us-west-2"
    dynamodb_table  = "lazy_tf_state"
    encrypt         = true
    kms_key_id      = "arn:aws:kms:us-west-2:108141096600:key/fc9bb6d7-4f0d-4b99-a830-85951933c030"
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