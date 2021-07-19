output "db_result" {
  value     = module.db
  sensitive = true
  description = "Refer https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest?tab=outputs for values"
}

output "secret_result" {
  value = aws_secretsmanager_secret.db
  description = "Refer https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret#attributes-reference"
}

output "host_name" {
  value = "${var.domain_name}.elk.${data.aws_route53_zone.zone.name}"
  description = "Recommend using this host name for no interruption"
}
