resource "aws_efs_mount_target" "default" {
  for_each = { for o in var.data_share_subnets : "${o.file_system_id}:${o.subnet_id}" => o }

  file_system_id  = each.value.file_system_id
  subnet_id       = each.value.subnet_id
  security_groups = var.security_groups
}
