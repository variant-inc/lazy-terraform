# Lazy AWS API Gateway v2 Module

Module to deploy an API Gateway (HTTP only at the moment) in a lazy fashion

Based off of [terraform-aws-apigateway-v2](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2)

## Using this module

Here is an example of using this terraform module:

```terraform
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}

module "api_gateway" {
  source = "github.com/variant-inc/lazy-terraform//api_gateway?ref=v1"

  name         = "test-api-gateway"
  domain  = "dev-drivevariant.com"
  subdomain    = "test-api-gateway.api-gateway"
  user_tags    = {
    team    = "engineering"
    owner   = "Variant"
    purpose = "testing api gateway"
  }
  octopus_tags = var.octopus_tags

  authorizer_audience = "0oa11hehq4wUPWXZH5d7"
  authorizer_issuer   = "https://office-drivevariant.okta.com"
  
  cors_configuration = {
    allow_headers     = ["content-type", "authorization", "x-api-key"]
    allow_methods     = ["*"]
    allow_origins     = ["*"]
    allow_credentials = true
    max_age           = 600
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
```

## Inputs

 | Name                         | Type          | Default             | Example                      |
 | ---------------------------- | ------------- | ------------------- | ---------------------------- |
 | name                         | string        |                     | test-api-gateway             |
 | description                  | string        | null                |                              |
 | domain                       | string        |                     | dev-drivevariant.com         |
 | subdomain                    | string        |                     | test-api-gateway.api-gateway |
 | user_tags                    | map           |                     | See below                    |
 | octopus_tags                 | map           |                     | See below                    |
 | authorizer_audience          | string        |                     |                              |
 | authorizer_issuer            | string        |                     |                              |
 | cors_configuration           | map           |                     |                              |
 | integrations                 | map           |                     |                              |
 | default_route_settings       | map           |                     |                              |


For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as and import via octo.tfvars.json in your project.

```terraform
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```