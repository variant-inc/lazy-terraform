resource "random_id" "random_id_prefix" {
  byte_length = 2
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  vpc_name           = var.vpc_name
}

module "networking" {
  source = "./modules/networking"

  region             = var.region
  vpc_cidr           = var.vpc_cidr
  availability_zones = data.aws_availability_zones.available.names
  vpc_name           = local.vpc_name
}
