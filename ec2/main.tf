
locals {
  common_tags = {
    "Name" = var.ec2_instance_name
    "Purpose" = var.instance_purpose
    "Owner" = var.instance_owner
  }
  default_sg_rule = {
    "ssm": {
        "type" :"egress",
        "from_port":"0",
        "to_port":"65535",
        "protocol":"TCP",
        "description":"Default egress to any for SSM access",
        "cidr_blocks": ["0.0.0.0/0"]
    }
  }
  merged_sg_rules = merge(local.default_sg_rule,var.security_group_rules_data)
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:type"
    values = [var.subnet_type] # insert values here
  }
}

resource "random_shuffle" "random_subnet" {
  input        = data.aws_subnet_ids.private.ids
  result_count = 1
}

resource "aws_eip" "ec2_instance_eip" {
  count = var.subnet_type == "public" ? 1 : 0
  vpc  = true
  tags = local.common_tags
}

resource "aws_security_group" "ec2_security_group" {
  name        = "${var.ec2_instance_name}-ec2"
  description = "Security group for ${var.ec2_instance_name}"
  vpc_id      = var.vpc_id
  tags = local.common_tags
  
}

resource "aws_security_group_rule" "ec2_security_group_rules" {
  for_each = local.merged_sg_rules
  description = each.value.description
  type = each.value.type
  from_port = each.value.from_port
  to_port = each.value.to_port
  protocol = each.value.protocol
  security_group_id = aws_security_group.ec2_security_group.id
  cidr_blocks = each.value.cidr_blocks

}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.ec2_instance_name}-ec2"
  role = var.ec2_instance_role
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.16.0"
  name = var.ec2_instance_name
  ami = var.ami_id
  associate_public_ip_address = var.associate_public_ip_address
  instance_type = var.ec2_instance_type
  ebs_optimized = var.ebs_optimized
  monitoring = true
  tags = local.common_tags
  subnet_id = random_shuffle.random_subnet.result[0]
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  root_block_device = [{
    volume_type = var.ebs_vol_type
    volume_size = var.ebs_volume_size
    kms_key_id = var.kms_key_id
    encrypted = true
  }]
}

resource "aws_eip_association" "ec2_instance" {
  count = var.subnet_type == "public" ? 1 : 0
  instance_id   = module.ec2-instance.id[0]
  allocation_id = aws_eip.ec2_instance_eip[0].id
}


module "metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 1.0"

  alarm_name          = "${var.ec2_instance_name}_cpu_usage"
  alarm_description   = "CPU usage alarm for ${var.ec2_instance_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 80
  period              = 60
  unit                = "Count"

  namespace   = var.ec2_instance_name
  metric_name = "CPUUtilization"
  statistic   = "Maximum"

  alarm_actions = [var.alarm_sns_arn]
}


output "instance_arn" {
  value = module.ec2-instance.arn
}

output "instance_id" {
  value = module.ec2-instance.id
}