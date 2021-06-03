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

locals {
  description = "Used by ${var.identifier} for ${var.user_tags.purpose}"

  postgres_parameters = [
    {
      name         = "rds.logical_replication"
      value        = 1
      apply_method = "pending-reboot"
    },
    {
      name  = "wal_sender_timeout"
      value = 0
    }
  ]

  parameters = var.engine == "postgres" ? local.postgres_parameters : []

  # https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf#L7-L176
  sg_ingress_rule = var.engine == "postgres" ? "postgresql-tcp" : "all-all"

  # tags = { for k, v in module.tags.tags: k => v if k != "name" }
}

# Create security group
module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.identifier}-rds"
  description = "Security group for ${var.identifier} RDS"
  vpc_id      = module.vpc.vpc.id
  tags        = module.tags.tags

  ingress_cidr_blocks = var.inbound_cidrs
  ingress_rules       = [local.sg_ingress_rule]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

# Creating db module
module "db" {
  source = "terraform-aws-modules/rds/aws"

  db_subnet_group_description     = local.description
  db_subnet_group_name            = var.identifier
  db_subnet_group_use_name_prefix = false

  parameter_group_description     = local.description
  parameter_group_name            = var.identifier
  parameter_group_use_name_prefix = false
  parameters                      = local.parameters
  family                          = var.family

  identifier                          = var.identifier
  allocated_storage                   = var.allocated_storage
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  apply_immediately                   = var.apply_immediately
  backup_retention_period             = 7
  backup_window                       = var.backup_window
  copy_tags_to_snapshot               = true
  create_random_password              = true
  tags                                = module.tags.tags
  deletion_protection                 = true
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
  username                            = var.username
  vpc_security_group_ids              = [module.security_group.security_group_id]
}

resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.identifier}-rds"
  tags                    = module.tags.tags
  description             = local.description
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = module.db.db_master_password
}