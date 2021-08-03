module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags = var.user_tags
  octopus_tags = var.octopus_tags
  name = var.name
}

locals {
  domain_name = var.domain
  subdomain   = var.subdomain
  vpc_id      = var.vpc_id == "" ? module.vpc.vpc.id : var.vpc_id
}

module "vpc" {
  source = "github.com/variant-inc/lazy-terraform//submodules/vpc?ref=v1"
}

module "subnets" {
  source = "github.com/variant-inc/lazy-terraform//submodules/subnets?ref=v1"

  vpc_id = local.vpc_id
}

data "aws_route53_zone" "this" {
  name = local.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name               = local.domain_name
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["${local.subdomain}.${local.domain_name}"]
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.subdomain
  type    = "CNAME"

  alias {
    name                   = module.api_gateway.apigatewayv2_domain_name_configuration[0].target_domain_name
    zone_id                = module.api_gateway.apigatewayv2_domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

module "api_gateway_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "api-gateway-sg-${var.name}"
  description = "Security group for ${var.name} API Gateway"
  vpc_id      = module.vpc.vpc.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]

  egress_rules = ["all-all"]
}

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  # create_api_domain_name = false

  name          = var.name
  description   = var.description
  protocol_type = var.protocol_type

  cors_configuration = var.cors_configuration

  domain_name                 = local.domain_name
  domain_name_certificate_arn = module.acm.acm_certificate_arn

  default_route_settings = var.default_route_settings

  integrations = var.integrations

  vpc_links = {
    internal-vpc = {
      name               = "${var.name}-vpc-links"
      security_group_ids = [module.api_gateway_security_group.security_group_id]
      subnet_ids         = module.subnets.subnets.ids
    }
  }
}

resource "aws_apigatewayv2_authorizer" "authorizer" {
  api_id           = module.api_gateway.apigatewayv2_api_id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = var.name

  jwt_configuration {
    audience = ["${var.authorizer_audience}"] # eg: abcfEFgh1231123
    issuer   = var.authorizer_issuer          # eg: https://office-drivevariant.okta.com
  }
}