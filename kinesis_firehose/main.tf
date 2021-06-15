# Create tags
module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"
  # source = "../submodules/tags" # For testing
  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
  name         = var.kinesis_firehose_delivery_stream
}

# Create resource for kinesis firehose delivery stream
resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = var.kinesis_firehose_delivery_stream
  tags        = module.tags.tags
  destination = "extended_s3"
  server_side_encryption {
    enabled = true
  }

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = aws_s3_bucket.bucket.arn
    prefix              = var.firehose_s3.bucket_content_prefix
    error_output_prefix = var.firehose_s3.bucket_content_error_prefix
    buffer_size         = var.firehose_s3.buffer_size
    buffer_interval     = var.firehose_s3.buffer_interval
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "log_group-${var.kinesis_firehose_delivery_stream}"
      log_stream_name = "log_stream-${var.kinesis_firehose_delivery_stream}"
    }

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.lambda_processor.arn}:$LATEST"
        }
      }
    }
  }
}

# Create resource S3 bucket where firehose will stream records
resource "aws_s3_bucket" "bucket" {
  bucket = "s3-${var.kinesis_firehose_delivery_stream}"
  acl    = "private"
  tags   = module.tags.tags
}

# Create resource lambda function that can transform the incoming stream to S3
resource "aws_lambda_function" "lambda_processor" {
  filename      = var.firehose_lambda.filename
  function_name = "${var.kinesis_firehose_delivery_stream}-lambda"
  role          = aws_iam_role.s3_extended_role.arn
  handler       = var.firehose_lambda.handler
  runtime       = var.firehose_lambda.runtime
  timeout       = var.firehose_lambda.timeout
  memory_size   = var.firehose_lambda.memory_size
  tags          = module.tags.tags
}

