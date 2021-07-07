data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs_names = data.aws_availability_zones.available.names
  private_subnets = [
    for i in range(length(local.azs_names)) : cidrsubnet(var.cidr, 4, (2 * i) + 1)
  ]
  public_subnets = [
    for i in range(length(local.azs_names)) : cidrsubnet(var.cidr, 4, 2 * i)
  ]
}

module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags

  name = var.name
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = false

  tags = { for k, v in module.tags.tags: k => v if k != "Name" }
  private_subnet_tags = {
    type = "private"
  }
  public_subnet_tags = {
    type = "public"
  }
}
