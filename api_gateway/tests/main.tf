terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

provider "aws" {}

module "api_gateway" {
  source = "../"

  name         = var.name
  domain       = var.domain
  subdomain    = var.subdomain
  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags

  authorizer_audience = var.authorizer_audience
  authorizer_issuer   = var.authorizer_issuer
  
  cors_configuration = {
    allow_headers     = ["content-type", "authorization", "x-api-key"]
    allow_methods     = ["*"]
    allow_origins     = ["*"]
  }

  integrations = {
    "GET /some-route" = {
      integration_type   = "HTTP_PROXY"
      integration_uri    = "https://example.com/api/endpoint"
      authorization_type = "JWT"
      authorizer_id      = module.api_gateway.authorizer.id
    }
  }
}
