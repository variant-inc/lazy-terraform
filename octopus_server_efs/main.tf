locals {
  volumes = [
    "octopus-artifacts",
    "octopus-repository",
    "octopus-task-logs"
  ]
}

data "aws_vpc" "eks_vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = ["*Private*"] # insert values here
  }
}

resource "aws_efs_file_system" "octopus" {
  count       = length(local.volumes)
  encrypted   = true

  tags = {
    Name    = element(local.volumes, count.index)
    purpose = "Octopus Server"
    owner   = "devops"
    team    = "devops"
  }
}


resource "aws_security_group" "octopus" {
  name        = "octopus-server-efs"
  description = "SG Octopus Server EFS"
  vpc_id      = var.vpc_id
  tags = {
    Name    = "octopus-server-efs"
    purpose = "SG Octopus Server EFS"
    owner   = "devops"
    team    = "devops"
  }
}

resource "aws_security_group_rule" "ingress" {
  description       = "octopus-server-efs"
  type              = "ingress"
  from_port         = "2049" # NFS
  to_port           = "2049"
  protocol          = "tcp"
  security_group_id = aws_security_group.octopus.id
  cidr_blocks       = [data.aws_vpc.eks_vpc.cidr_block]
}

resource "aws_security_group_rule" "egress" {
  description       = "octopus-server-efs"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.octopus.id
  cidr_blocks       = ["0.0.0.0/0"]
}

module "mount_targets" {
  source             = "./mount_targets"

  data_share_subnets = [
    for pair in setproduct(aws_efs_file_system.octopus, sort(data.aws_subnet_ids.private.ids)) : {
      file_system_id = pair[0].id
      subnet_id      = pair[1]
    }
  ]
  security_groups = [aws_security_group.octopus.id]
}
