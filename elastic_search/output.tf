output "elk_master_password" {
  value     = lookup(var.master_user_options, "master_user_password", random_password.password.result)
  sensitive = true
}

output "kibana_endpoint" {
  description = "URL to access Kibana"
  value       = aws_elasticsearch_domain.cluster.kibana_endpoint
}

output "result" {
  description = "Complete Result"
  value       = aws_elasticsearch_domain.cluster
}

output "hostname" {
  description = "Route53 Host Name"
  value       = aws_route53_record.route.fqdn
}
