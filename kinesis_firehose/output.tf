output "firehose_delivery_stream_arn" {
  value = aws_kinesis_firehose_delivery_stream.extended_s3_stream.arn
}

output "firehose_s3_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "firehose_lambda_arn" {
  value = aws_lambda_function.lambda_processor.arn
}

