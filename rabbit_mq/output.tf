output "broker_arn" {
  value = aws_mq_broker.mq.arn
}

output "broker_id" {
  value = aws_mq_broker.mq.id
}

output "broker_url" {
  value = aws_mq_broker.mq.instances.0.console_url
}

output "broker_user" {
  value = aws_mq_broker.mq.user
}

output "broker_amqp_endpoint" {
  value = aws_mq_broker.mq.instances.0.endpoints.0
}

output "broker_aws_secret_name" {
  value = aws_secretsmanager_secret.broker_password.name
}

output "broker_console_endpoint" {
  value = aws_mq_broker.mq.instances.0.console_url
}