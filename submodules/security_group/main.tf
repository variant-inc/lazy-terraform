# Get Open VPN security group for ES securtiy group
data "aws_instances" "openvpn" {
  instance_tags = {
    openvpn = "true"
  }
}

locals {
  default_sg_rules = {
    "ec_redis_ingress" : {
      "type" : "ingress",
      "from_port" : var.port,
      "to_port" : var.port,
      "protocol" : var.protocol,
      "description" : "inbound_cidrs",
      "cidr_blocks" : var.inbound_cidrs
    },
    "ec_tcp_egress" : {
      "type" : "egress",
      "from_port" : "0",
      "to_port" : "65535",
      "protocol" : "all",
      "description" : "",
      "cidr_blocks" : ["0.0.0.0/0"]
    }
  }
}

# ES related resources
resource "aws_security_group" "security_group" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name}"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "security_group_rules" {
  for_each = local.default_sg_rules

  description       = each.value.description
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.security_group.id
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "openvpn" {
  count = length(data.aws_instances.openvpn.private_ips)

  description       = "openvpn"
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = var.protocol
  security_group_id = aws_security_group.security_group.id
  cidr_blocks       = ["${data.aws_instances.openvpn.private_ips[count.index]}/32"]
}
