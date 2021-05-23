locals {
  common_tags = {
    "Name" = var.broker_name
    "Purpose" = var.broker_purpose
    "Owner" = var.broker_owner
  }
}
resource "aws_mq_broker" "mq" {
  broker_name        = var.broker_name
  engine_type        = var.engine_type
  engine_version     = var.engine_version
  host_instance_type = var.broker_instance_type
  user {
    username = var.username
    password = var.password
  }
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  deployment_mode = var.deployment_mode
  logs {
      general = var.cloudwatch_general_logs
  }
  maintenance_window_start_time {
    day_of_week = var.day_of_week
    time_of_day = var.time_of_day
    time_zone = var.time_zone
  }
  publicly_accessible = true
  tags = local.common_tags
}

output "broker_arn" {
  value = aws_mq_broker.mq.arn
}

output "broker_id" {
  value = aws_mq_broker.mq.id
}

output "broker_url" {
    value = aws_mq_broker.mq.instances.0.console_url
}