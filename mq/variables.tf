variable "profile" {
  type = string
  default = "default"
  description = "Credentials profile for AWS provider"
}

variable "region" {
  type = string
  default = "us-east-1"
  description = "Default region for AWS provider"
}

variable "broker_name" {
    type = string
    default = "broker-name-not-provided"
    description = "Name of the Amazon MQ Broker"
}

variable "engine_type" {
    default = "RabbitMQ"
    description = "This terraform module will currently support only RabbitMQ"
}

variable "engine_version" {
    type = string
    default = "3.8.11"
    description = "This is the engine version for RabbitMQ"
    validation {
      condition = contains(["3.8.6", "3.8.11"], lower(var.engine_version))
      error_message = "Unsupported engine version for AWS MQ where engine type is RabbitMQ."
    }
}

variable "broker_instance_type" {
    type = string
    default = "mq.m5.large"
    description = "This is the broker instance type for RabbitMQ"
    validation {
      condition = contains(["mq.m5.large", "mq.m5.xlarge", "mq.m5.2xlarge", "mq.m5.4xlarge"], lower(var.broker_instance_type))
      error_message = "Unsupported broker instance type for AWS MQ where engine type is RabbitMQ."
    }
}

variable "username" {
    type = string
    default = "rmqadmin"
    description = "Admin username for AWS MQ where engine type is RabbitMQ"
}

variable "password" {
    type = string
    default = "Variant2021!"
    description = "Admin password for AWS MQ where engine type is RabbitMQ"
    sensitive = true
}

variable "auto_minor_version_upgrade" {
    type = bool
    default = false
    description = "Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available"
}

variable "deployment_mode" {
    type = string
    default = "CLUSTER_MULTI_AZ"
    description = "Deployment mode of the broker"
    validation {
      condition = contains(["SINGLE_INSTANCE", "CLUSTER_MULTI_AZ", "ACTIVE_STANDBY_MULTI_AZ"], upper(var.deployment_mode))
      error_message = "Unsupported deployment mode for AWS MQ where engine type is RabbitMQ."
    }
}

variable "cloudwatch_general_logs" {
    type = bool
    default = true
    description = "Enables general logging via CloudWatch"
}

variable "day_of_week" {
    type = string
    default = "SUNDAY"
    description = "Day of week to schedule maintenance"
    validation {
      condition = contains(["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"], upper(var.day_of_week))
      error_message = "Unsupported deployment mode for AWS MQ where engine type is RabbitMQ."
    }
}

variable "time_of_day" {
    type = string
    default = "05:00"
    description = "Time of day to schedule maintenance. Need to be in 24 hour format"
}

variable "time_zone" {
    type = string
    default = "UTC"
    description = "Time zone to schedule maintenance. Valid time zone can be found at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones. Refer to TZ database name column."
}

variable "broker_purpose" {
    type = string
    default = "broker-purpose-not-provided"
    description = "Purpose of the Amazon MQ Broker"
}

variable "broker_owner" {
    type = string
    default = "broker-owner-not-provided"
    description = "Owner of the Amazon MQ Broker"
}







