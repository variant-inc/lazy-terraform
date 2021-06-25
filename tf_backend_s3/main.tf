module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  name         = var.name
  octopus_tags = var.octopus_tags
}

resource "random_string" "random" {
  length      = 7
  special     = false
  lower       = true
  min_numeric = 3
  upper       = false
}

locals {
  bucket_name = "${var.name}-${random_string.random.result}"
}

module "bucket" {
  source  = "github.com/variant-inc/lazy-terraform//s3?ref=v1"
  profile = "custom"

  region      = var.region
  bucket_name = local.bucket_name

  lazy_api_key  = var.lazy_api_key  # If run from octopus, this will be auto set
  lazy_api_host = var.lazy_api_host # If run from octopus, this will be auto set
  user_tags     = var.user_tags
  octopus_tags  = var.octopus_tags # If run from octopus, this will be auto set
  replication   = false
  role_arn      = "arn:aws:iam::660075424663:role/lazy-octopus-devops"
}

module "dynamodb_table" {
  source = "github.com/variant-inc/lazy-terraform//dynamo_db?ref=v1"

  table_name    = var.name
  hash_key      = "LockID"
  hash_key_type = "S"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags

  attributes = [
    {
      name = "LockID",
      type = "S",
    }
  ]
}

