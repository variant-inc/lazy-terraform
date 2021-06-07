# Create tags
module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"
  # source = "../submodules/tags" # For testing
  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
  name         = var.broker_name
}

# Create vpc
module "vpc" {
  source = "github.com/variant-inc/lazy-terraform//submodules/vpc?ref=v1"
}

# Create security group
module "security_group" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "${var.broker_name}-rmq"
  description         = "Security group for ${var.broker_name} RabbitMQ"
  vpc_id              = module.vpc.vpc.id
  tags                = module.tags.tags
  ingress_cidr_blocks = var.inbound_cidrs
  ingress_rules       = ["rabbitmq-4369-tcp", "rabbitmq-5671-tcp", "rabbitmq-5672-tcp", "rabbitmq-15672-tcp", "rabbitmq-25672-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}

# Get subnets
module "subnets" {
  source = "github.com/variant-inc/lazy-terraform//submodules/subnets?ref=v1"
  vpc_id = module.vpc.vpc.id
  type   = "public"
}

# Create a resource to generate random password
resource "random_password" "password" {
  length           = 12
  special          = false
  lower            = true
  number           = true
  upper            = true
  min_numeric      = 4
  min_lower        = 6
  min_upper        = 1
  min_special      = 1
  override_special = "!%()[]{}$#^@&"
}

# Pick one incase instance number is one
resource "random_shuffle" "random_subnet" {
  input        = module.subnets.subnets.ids
  result_count = 1
}

# Create a resource for AWS RabbitMQ Broker
resource "aws_mq_broker" "mq" {
  broker_name        = var.broker_name
  engine_type        = var.engine_type
  engine_version     = var.engine_version
  host_instance_type = var.broker_instance_type
  user {
    username = var.username
    password = random_password.password.result
  }
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  deployment_mode            = var.deployment_mode
  logs {
    general = var.cloudwatch_general_logs
  }
  maintenance_window_start_time {
    day_of_week = var.maintenance_window.day_of_week
    time_of_day = var.maintenance_window.time_of_day
    time_zone   = "UTC"
  }
  publicly_accessible = var.publicly_accessible
  tags                = module.tags.tags
  security_groups     = var.publicly_accessible ? null : [module.security_group.security_group_id]
  subnet_ids          = var.publicly_accessible ? null : var.deployment_mode != "SINGLE_INSTANCE" ? module.subnets.subnets.ids : [random_shuffle.random_subnet.result[0]]
}

