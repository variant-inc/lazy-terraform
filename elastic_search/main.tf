# Get EKS VPC id and cidr to add to securtiy group rules
data "aws_vpcs" "eks_vpcs" {
    filter {
        name = "tag-key"
        values = ["alpha.eksctl.io/eksctl-version"]
    }
}

data "aws_vpc" "eks_vpc" {
  id = tolist(data.aws_vpcs.eks_vpcs.ids)[0]
}

# Get Open VPN security group for ES securtiy group
data "aws_security_groups" "openvpn" {
  tags = {
    openvpn = "true"
 }
}

# Get subnets for ES cluster nodes
data "aws_subnet_ids" "private_subnets" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:type"
    values = ["private"]
  }
}

# Get data for tags
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
    instance_count =  lookup(var.cluster_config, "instance_count" , 1)
    user_tags = {
        for k, v in var.user_tags:
          replace(k, "-", "/") => v
    }

    common_tags = {
        "Name" = var.domain_name
        "DeployedBy" = data.aws_caller_identity.current.user_id
        "aws/account_number" = data.aws_caller_identity.current.id
    }
    
    tags = merge(local.common_tags, local.user_tags)
    log_publishing_options = { "index_slow_logs": "INDEX_SLOW_LOGS", "search_slow_logs": "SEARCH_SLOW_LOGS", "es_application_logs": "ES_APPLICATION_LOGS", "audit_logs": "AUDIT_LOGS"}
    eks_cidr_block = data.aws_vpc.eks_vpc.cidr_block_associations[0]["cidr_block"]
    open_vpn_sgs = {
        for sg in data.aws_security_groups.openvpn.ids:
        "open_vpn_ingress_${sg}" => {
            "type" :"ingress",
            "from_port":"443",
            "to_port":"443",
            "protocol":"TCP",
            "description":"",
            "cidr_blocks": null,
            "source_security_group_id": sg
        }
    }
    default_sg_rules = {
        "es_http_ingress": {
            "type" :"ingress",
            "from_port":"443",
            "to_port":"443",
            "protocol":"TCP",
            "description":"",
            "cidr_blocks": [local.eks_cidr_block],
            "source_security_group_id": null
        },
        "es_tcp_ingress": {
            "type" :"ingress",
            "from_port":"0",
            "to_port":"65535",
            "protocol":"TCP",
            "description":"",
            "cidr_blocks": [local.eks_cidr_block],
            "source_security_group_id": null
        },
        "es_tcp_egree": {
            "type" :"egress",
            "from_port":"0",
            "to_port":"65535",
            "protocol":"TCP",
            "description":"",
            "cidr_blocks": [local.eks_cidr_block],
            "source_security_group_id": null
        }
    }
    sg_rules = merge(local.open_vpn_sgs, local.default_sg_rules)
}

# Pick one incase instance number is one
resource "random_shuffle" "random_subnet" {
  input        = data.aws_subnet_ids.private_subnets.ids
  result_count = 1
}

# ES related resources
resource "aws_security_group" "elk_security_group" {
  name        = "elk-${var.domain_name}-sg"
  description = "Security group for ${var.domain_name}"
  vpc_id      = var.vpc_id
  tags = local.tags
}

resource "aws_security_group_rule" "elk_security_group_rules" {
  for_each = local.sg_rules
  description = each.value.description
  type = each.value.type
  from_port = each.value.from_port
  to_port = each.value.to_port
  protocol = each.value.protocol
  security_group_id = aws_security_group.elk_security_group.id
  cidr_blocks = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
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
  name = "elk/${var.domain_name}/${each.key}"
  tags = local.tags
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
    elasticsearch_version = "7.10"
    domain_endpoint_options {
        enforce_https=true
        tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
    }
    advanced_security_options {
        enabled = true
        internal_user_database_enabled = true
        master_user_options {
            master_user_name = var.master_user_options["master_user_name"]
            # master_user_arn = var.master_user_options["master_user_arn"]
            master_user_password = lookup( var.master_user_options, "master_user_password", random_password.password.result)
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
            instance_type = contains("instance_type" , var.cluster_config) ? var.cluster_config["instance_type"] : "r5.large.elasticsearch"
            instance_count = local.instance_count
            dedicated_master_enabled = var.cluster_config["dedicated_master_enabled"]
            dedicated_master_count = var.cluster_config["dedicated_master_count"]
            zone_awareness_enabled = true
            zone_awareness_config {
                availability_zone_count = 3
            }
        }

    }
    dynamic "cluster_config" {
        for_each = var.cluster_config["dedicated_master_enabled"] == false ? [1] : []
        content{
            instance_type = lookup(var.cluster_config, "instance_type" , "r5.large.elasticsearch")
            instance_count = local.instance_count
            zone_awareness_enabled = true
            zone_awareness_config {
                availability_zone_count = 3
            }
        }
    }
    vpc_options {
        subnet_ids = local.instance_count == "1" || local.instance_count == 1 ? [random_shuffle.random_subnet.result[0]] : data.aws_subnet_ids.private_subnets.ids
        security_group_ids = [aws_security_group.elk_security_group.id]
    }
    snapshot_options {
        automated_snapshot_start_hour = 23
    }
    dynamic "log_publishing_options" {
        for_each = local.log_publishing_options
        content {
            enabled=true
            cloudwatch_log_group_arn = aws_cloudwatch_log_group.elk_log_groups[log_publishing_options.key].arn
            log_type = log_publishing_options.value           
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
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
    }
  ]
}
POLICY

    tags = local.tags
}