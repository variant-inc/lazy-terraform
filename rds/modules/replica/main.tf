locals {
  description          = "Used by ${var.identifier} for ${var.user_tags.purpose}"
  postgres_log_exports = ["postgresql", "upgrade"]
}

data "aws_kms_alias" "rds" {
  name = "alias/aws/rds"
}

module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  name         = var.identifier
  octopus_tags = var.octopus_tags
}

module "vpc" {
  source = "github.com/variant-inc/lazy-terraform//submodules/vpc?ref=v1"
}

# Get subnets for ES cluster nodes
module "subnets" {
  source = "github.com/variant-inc/lazy-terraform//submodules/subnets?ref=v1"

  vpc_id = module.vpc.vpc.id
}

# Create security group
module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.identifier}-rds"
  description = "Security group for ${var.identifier} RDS"
  vpc_id      = module.vpc.vpc.id
  tags        = module.tags.tags

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = [var.sg_ingress_rule]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

# Creating db module
module "db_east_2" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  replicate_source_db = var.primary_db_arn

  db_subnet_group_description     = local.description
  db_subnet_group_name            = var.identifier
  db_subnet_group_use_name_prefix = false

  parameter_group_description     = local.description
  parameter_group_name            = var.identifier
  parameter_group_use_name_prefix = false
  parameters                      = var.parameters
  family                          = var.family

  identifier                          = var.identifier
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  apply_immediately                   = var.apply_immediately
  copy_tags_to_snapshot               = true
  tags                                = module.tags.tags
  engine                              = var.engine
  engine_version                      = var.engine_version
  iam_database_authentication_enabled = true
  instance_class                      = var.instance_class
  iops                                = var.storage_type == "gp2" ? 0 : var.iops
  maintenance_window                  = var.maintenance_window
  max_allocated_storage               = var.max_allocated_storage
  storage_encrypted                   = true
  storage_type                        = var.storage_type
  subnet_ids                          = module.subnets.subnets.ids
  vpc_security_group_ids              = [module.security_group.security_group_id]
  cross_region_replica                = true
  kms_key_id                          = data.aws_kms_alias.rds.target_key_arn

  multi_az            = true
  skip_final_snapshot = true

  ## monitoring
  create_monitoring_role = false
  monitoring_role_arn    = var.monitoring_role_arn
  monitoring_interval    = 1

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  ## performance monitoring
  performance_insights_enabled          = true
  performance_insights_retention_period = 731
  performance_insights_kms_key_id       = data.aws_kms_alias.rds.arn

  timeouts = {
    "create" : "140m",
    "delete" : "140m",
    "update" : "180m"
  }
}
