output "efs_ids" {
  value = [aws_efs_file_system.octopus.*.id]
}
