module "bucket" {
  source = "github.com/variant-inc/lazy-terraform//s3?ref=v1"

  region        = var.region
  bucket_prefix = var.bucket_prefix

  lazy_api_key  = var.lazy_api_key
  lazy_api_host = var.lazy_api_host
  user_tags     = var.user_tags
  octopus_tags  = var.octopus_tags

  env                = "prod"
  aws_role_to_assume = var.aws_role_to_assume
}

module "dynamodb_table" {
  source = "github.com/variant-inc/lazy-terraform//dynamo_db?ref=v1"

  table_name = var.table_name
  hash_key   = "LockID"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags

  attributes = [
    {
      name = "LockID",
      type = "S",
    }
  ]
}

