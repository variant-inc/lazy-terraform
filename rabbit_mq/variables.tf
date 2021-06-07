variable "profile" {
  type        = string
  default     = "default"
  description = "Credentials profile for AWS provider"
}

variable "user_tags" {
  description = "Mandatory tags for the RabbitMQ resources"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "broker_name" {
  type        = string
  description = "Name of the Amazon MQ Broker"
}

variable "engine_version" {
  type        = string
  default     = "3.8.11"
  description = "This is the engine version for RabbitMQ"
}

variable "broker_instance_type" {
  type        = string
  default     = "mq.m5.large"
  description = "This is the broker instance type for RabbitMQ"
}

variable "username" {
  type        = string
  default     = "rmqadmin"
  description = "Admin username for AWS MQ where engine type is RabbitMQ"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available"
}

variable "deployment_mode" {
  type        = string
  default     = "CLUSTER_MULTI_AZ"
  description = "Deployment mode of the broker"
}

variable "cloudwatch_general_logs" {
  type        = bool
  default     = true
  description = "Enables general logging via CloudWatch"
}

variable "maintenance_window" {
  description = "Mandatory window for RabbitMQ"
  type = object({
    day_of_week = string
    time_of_day = string
  })
  default = {
    day_of_week = "SUNDAY"
    time_of_day = "05:00"
  }
}

variable "inbound_cidrs" {
  description = "CIDR block to expect requests to originate from ie the source/destination in es' security group"
  default     = ["0.0.0.0/0"]
}

variable "publicly_accessible" {
  type    = bool
  default = false
}









