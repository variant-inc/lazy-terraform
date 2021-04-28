resource "aws_efs_mount_target" "default" {
  count       = length(var.data_share_subnets.subnet_id)

  file_system_id  = var.data_share_subnets.file_system_id
  subnet_id       = element(var.data_share_subnets.subnet_id, count.index)
  security_groups = var.security_groups
}
