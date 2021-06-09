output "db_result" {
  value     = module.db
  sensitive = true
}

output "secret_result" {
  value = aws_secretsmanager_secret.db
}
