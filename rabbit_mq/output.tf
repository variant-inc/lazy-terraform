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
  value     = aws_mq_broker.mq.user
  sensitive = true
}
