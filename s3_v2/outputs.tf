output "bucket_name" {
  value       = aws_s3_bucket.bucket.bucket
  description = "Name of the bucket name + prefix"
}

output "bucket_arn" {
  value       = "arn:aws:s3:::${local.name}"
  description = "ARN of the bucket name + prefix"
}
