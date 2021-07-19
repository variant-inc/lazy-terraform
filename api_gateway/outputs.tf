output "api_gateway" {
  description = "See https://registry.terraform.io/modules/terraform-aws-modules/apigateway-v2/aws/latest?tab=outputs"
  value       = module.api_gateway
}

output "authorizer" {
  value = aws_apigatewayv2_authorizer.authorizer
}

output "api_fqdn" {
  description = "List of Route53 records"
  value       = aws_route53_record.api.fqdn
}

output "api_endpoint" {
  description = "FQDN of an API endpoint"
  value       = "https://${aws_route53_record.api.fqdn}"
}