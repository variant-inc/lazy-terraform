
locals {
  common_tags = {
    "Name" = var.ec2_instance_name
    "Purpose" = var.instance_purpose
    "Owner" = var.instance_owner
  }
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

data "aws_subnet" "selected" {
  id = random_shuffle.random_subnet.result[0]
}


resource "aws_eip" "ec2_instance_eip" {
  vpc  = true
  tags = local.common_tags
}


resource "aws_ebs_volume" "ec2_ebs_volume" {
  availability_zone = module.ec2-instance.availability_zone[0]
  size = var.ebs_volume_size
  encrypted = true
  tags = local.common_tags
  kms_key_id = var.kms_key_id
  type = var.ebs_vol_type
}


resource "aws_security_group" "ec2_security_group" {
  name        = "${var.ec2_instance_name}-ec2"
  description = "Security group for ${var.ec2_instance_name}"
  vpc_id      = var.vpc_id
  tags = local.common_tags
  
}

resource "aws_security_group_rule" "ec2_security_group_rules" {
  for_each = var.security_group_rules_data
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
  # key_name = aws_key_pair.ec2_key.key_name
  monitoring = true
  tags = local.common_tags
  subnet_id = random_shuffle.random_subnet.result[0]
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
}

resource "aws_volume_attachment" "ebs_ec2_attachement" {
  device_name = var.ebs_device_name
  volume_id   = aws_ebs_volume.ec2_ebs_volume.id
  instance_id = module.ec2-instance.id[0]
}


resource "aws_eip_association" "ec2_instance" {
  instance_id   = module.ec2-instance.id[0]
  allocation_id = aws_eip.ec2_instance_eip.id
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