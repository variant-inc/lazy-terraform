data "aws_caller_identity" "current" {}

module "vpc" {
  source = "github.com/variant-inc/lazy-terraform//submodules/vpc?ref=v1"
}

locals {
  instance_count = lookup(var.cluster_config, "instance_count", 1)
  log_publishing_options = {
    "index_slow_logs" : "INDEX_SLOW_LOGS",
    "search_slow_logs" : "SEARCH_SLOW_LOGS",
    "es_application_logs" : "ES_APPLICATION_LOGS",
    "audit_logs" : "AUDIT_LOGS"
  }

  vpc_id = var.vpc_id == "" ? module.vpc.vpc.id : var.vpc_id
}

module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  name         = var.domain_name
  octopus_tags = var.octopus_tags
}

# Get subnets for ES cluster nodes
module "subnets" {
  source = "github.com/variant-inc/lazy-terraform//submodules/subnets?ref=v1"

  vpc_id = local.vpc_id
}

# Create security group
module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.identifier}-elk"
  description = "Security group for ${var.identifier} ELK"
  vpc_id      = local.vpc_id
  tags        = module.tags.tags

  ingress_cidr_blocks = var.inbound_cidrs
  ingress_rules = [
    "elasticsearch-rest-tcp",
    "elasticsearch-java-tcp",
    "https-443-tcp"
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

# Pick one incase instance number is one
resource "random_shuffle" "random_subnet" {
  input        = module.subnets.subnets.ids
  result_count = 1
}

resource "random_password" "password" {
  length           = 16
  special          = true
  lower            = true
  number           = true
  upper            = true
  min_numeric      = 2
  min_lower        = 2
  min_upper        = 3
  min_special      = 4
  override_special = "!%()[]{}$#^@&"
}

resource "aws_cloudwatch_log_group" "elk_log_groups" {
  for_each = local.log_publishing_options
  name     = "elk/${var.domain_name}/${each.key}"
  tags     = local.tags
}

resource "aws_cloudwatch_log_resource_policy" "example" {
  policy_name = "example"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_elasticsearch_domain" "variant-elk-cluster" {
  domain_name           = var.domain_name
  elasticsearch_version = var.es_version
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.master_user_options["master_user_name"]
      master_user_password = lookup(var.master_user_options, "master_user_password", random_password.password.result)
    }
  }
  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_volume_size
  }
  encrypt_at_rest {
    enabled = true
  }
  node_to_node_encryption {
    enabled = true
  }
  dynamic "cluster_config" {
    for_each = var.cluster_config["dedicated_master_enabled"] == true ? [1] : []
    content {
      instance_type            = contains("instance_type", var.cluster_config) ? var.cluster_config["instance_type"] : "r5.large.elasticsearch"
      instance_count           = local.instance_count
      dedicated_master_enabled = var.cluster_config["dedicated_master_enabled"]
      dedicated_master_count   = var.cluster_config["dedicated_master_count"]
      zone_awareness_enabled   = true
      zone_awareness_config {
        availability_zone_count = 3
      }
    }

  }
  dynamic "cluster_config" {
    for_each = var.cluster_config["dedicated_master_enabled"] == false ? [1] : []
    content {
      instance_type          = lookup(var.cluster_config, "instance_type", "r5.large.elasticsearch")
      instance_count         = local.instance_count
      zone_awareness_enabled = true
      zone_awareness_config {
        availability_zone_count = 3
      }
    }
  }
  vpc_options {
    subnet_ids = (
      (
        local.instance_count == "1" || local.instance_count == 1
      ) ? [random_shuffle.random_subnet.result[0]] : module.subnets.subnets.ids
    )
    security_group_ids = [module.security_group.security_group_id]
  }
  snapshot_options {
    automated_snapshot_start_hour = 23
  }
  dynamic "log_publishing_options" {
    for_each = local.log_publishing_options
    content {
      enabled                  = true
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.elk_log_groups[log_publishing_options.key].arn
      log_type                 = log_publishing_options.value
    }
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": {
        "AWS": "*"
      },
      "Effect": "Allow",
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
    }
  ]
}
POLICY

  tags = module.tags.tags
}
