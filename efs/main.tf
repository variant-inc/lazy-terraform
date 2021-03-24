data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = ["*Private*"] # insert values here
  }
}

resource "aws_efs_file_system" "efs" {
  encrypted   = true

  tags = {
    Name    = var.volume_name
    purpose = var.tag_purpose
    owner   = var.tag_owner
    team    = var.tag_team
  }
}

resource "aws_efs_access_point" "efs" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = 33
    uid = 33
    secondary_gids = [
      "2000"
    ]
  }
  root_directory {
    path = "/efs"
    creation_info {
      owner_gid = 33
      owner_uid = 33
      permissions = "0755"
    }
  }
}


resource "aws_security_group" "efs" {
  name        = var.volume_name
  description = var.tag_purpose
  vpc_id      = var.vpc_id
  tags = {
    Name    = var.volume_name
    purpose = var.tag_purpose
    owner   = var.tag_owner
    team    = var.tag_team
  }
}

resource "aws_security_group_rule" "ingress" {
  description       = "test"
  type              = "ingress"
  from_port         = "2049" # NFS
  to_port           = "2049"
  protocol          = "tcp"
  security_group_id = aws_security_group.efs.id
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "egress" {
  description       = "test"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.efs.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# module "mount_targets" {
#   source             = "./mount_targets"

#   data_share_subnets = {
#     file_system_id = aws_efs_file_system.octopus.id
#     subnet_id      = sort(data.aws_subnet_ids.private.ids)
#   }
#   security_groups = [aws_security_group.octopus.id]
# }
resource "aws_efs_mount_target" "default" {
  count       = length(sort(data.aws_subnet_ids.private.ids))

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = element(sort(data.aws_subnet_ids.private.ids), count.index)
  security_groups = [aws_security_group.efs.id]
}