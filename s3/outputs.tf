output "bucket_name" {
  value       = local.name
  description = "Name of the bucket name + prefix"
}

output "bucket_arn" {
  value       = "arn:aws:s3:::${local.name}"
  description = "ARN of the bucket name + prefix"
}
