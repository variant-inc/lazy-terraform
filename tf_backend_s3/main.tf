module "bucket" {
  source = "github.com/variant-inc/lazy-terraform//s3?ref=v1"

  region        = var.region
  bucket_prefix = var.bucket_prefix
  user_tags     = var.user_tags
  octopus_tags  = var.octopus_tags

  env = "prod"
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

module "bucket_vars" {
  count  = var.create_vars_bucket ? 1 : 0
  source = "github.com/variant-inc/lazy-terraform//s3?ref=v1"

  region        = var.region
  bucket_prefix = "${var.bucket_prefix}-vars"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags

  env = "prod"
}

