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
  postgres_log_exports = ["postgresql", "upgrade"]

  # mysql_parameters = [
  #   {
  #     name         = "binlog_format"
  #     value        = "ROW"
  #   },
  #   {
  #     name  = "binlog_checksum"
  #     value = "NONE"
  #   }
  # ]
  # mysql_log_exports = ["audit", "error", "general", "slowquery"]

  parameters = var.engine == "postgres" ? local.postgres_parameters : []

  # https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf#L7-L176
  sg_ingress_rule = var.engine == "postgres" ? "postgresql-tcp" : "all-all"

  vpc_id = var.vpc_id == "" ? module.vpc.vpc.id : var.vpc_id

  inbound_cidrs = concat(var.inbound_cidrs,
    (
      var.whitelist_openvpn && var.env != "prod" ? ["${data.aws_instance.openvpn[0].private_ip}/32"] : []
    ),
    (
      var.whitelist_eks ? module.eks_vpc[0].cidr_ranges : []
    )
  )
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

  vpc_id = local.vpc_id
}

module "eks_vpc" {
  count = var.whitelist_eks ? 1 : 0

  source = "github.com/variant-inc/lazy-terraform//submodules/eks-vpc?ref=v1"

  cluster_name = var.cluster_name
}

data "aws_instance" "openvpn" {
  count = var.whitelist_openvpn && var.env != "prod" ? 1 : 0

  instance_tags = {
    openvpn = "true"
  }
}

# Create security group
module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.identifier}-rds"
  description = "Security group for ${var.identifier} RDS"
  vpc_id      = local.vpc_id
  tags        = module.tags.tags

  ingress_cidr_blocks = local.inbound_cidrs
  ingress_rules       = [local.sg_ingress_rule]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

# Creating db module
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  db_subnet_group_description     = local.description
  db_subnet_group_name            = var.identifier
  db_subnet_group_use_name_prefix = false

  parameter_group_description     = local.description
  parameter_group_name            = var.identifier
  parameter_group_use_name_prefix = false
  parameters                      = local.parameters
  family                          = var.family

  identifier                          = var.identifier
  name                                = var.name
  allocated_storage                   = var.allocated_storage
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  apply_immediately                   = var.apply_immediately
  backup_retention_period             = 7
  backup_window                       = var.backup_window
  copy_tags_to_snapshot               = true
  create_random_password              = true
  tags                                = module.tags.tags
  deletion_protection                 = false
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

  # prod
  multi_az            = var.env == "prod" ? true : var.multi_az
  skip_final_snapshot = var.env == "prod" ? false : true

  ## monitoring
  create_monitoring_role = true
  monitoring_role_name   = "${var.identifier}-rds"
  monitoring_interval    = var.env == "prod" ? 1 : 60

  enabled_cloudwatch_logs_exports = var.env == "prod" ? (
    var.engine == "postgres" ? local.postgres_log_exports : []
  ) : []

  ## performance monitoring
  performance_insights_enabled          = var.env == "prod" ? true : var.performance_insights_enabled
  performance_insights_retention_period = var.env == "prod" ? 731 : 7
  performance_insights_kms_key_id       = data.aws_kms_alias.rds.arn

  timeouts = {
    "create" : "140m",
    "delete" : "140m",
    "update" : "180m"
  }
}

resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.identifier}-rds"
  tags                    = module.tags.tags
  description             = local.description
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = module.db.db_master_password
}

module "replica" {
  count  = var.env == "prod" ? 1 : 0
  source = "./modules/replica"

  providers = {
    aws = aws.replica
  }

  family                          = var.family
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  apply_immediately               = var.apply_immediately
  backup_window                   = var.backup_window
  maintenance_window              = var.maintenance_window
  engine                          = var.engine
  engine_version                  = var.engine_version
  identifier                      = var.identifier
  instance_class                  = var.instance_class
  iops                            = var.iops
  max_allocated_storage           = var.max_allocated_storage
  storage_type                    = var.storage_type
  multi_az                        = var.multi_az
  user_tags                       = var.user_tags
  octopus_tags                    = var.octopus_tags
  primary_db_arn                  = module.db.db_instance_arn
  parameters                      = local.parameters
  sg_ingress_rule                 = local.sg_ingress_rule
  enabled_cloudwatch_logs_exports = var.engine == "postgres" ? local.postgres_log_exports : []
  monitoring_role_arn             = module.db.enhanced_monitoring_iam_role_arn
}

module "postgres" {
  source = "./modules/postgres"

  host       = module.db.db_instance_address
  username   = var.username
  password   = module.db.db_master_password
  name       = "postgres"
  tags       = module.tags.tags
  enabled    = var.engine == "postgres"
  identifier = var.identifier
}

data "aws_route53_zone" "zone" {
  name = var.domain
}

resource "aws_route53_record" "route" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.identifier}.rds.${data.aws_route53_zone.zone.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.db.db_instance_address]
}
