output "efs_ids" {
  value = aws_efs_file_system.efs.id
}

output "access_point_ids" {
  value = aws_efs_access_point.efs.id
}
