locals {
  name = var.bucket_name != "" ? var.bucket_name : "${var.bucket_prefix}-${random_string.random.result}"
}

resource "random_string" "random" {
  length      = 16
  special     = false
  lower       = true
  upper       = false
  min_numeric = 3
}

module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  name = local.name

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.name
  acl    = "private"

  lifecycle {
    ignore_changes = [
      replication_configuration
    ]
  }

  lifecycle_rule {
    enabled = lookup(var.lifecycle_rule, "enabled",  null)

    prefix = lookup(var.lifecycle_rule, "prefix", null)

    abort_incomplete_multipart_upload_days = lookup(var.lifecycle_rule, "abort_incomplete_multipart_upload_days", null)

    transition {
      days          = lookup(var.lifecycle_rule.transition_storage_class, "days", null)
      storage_class = lookup(var.lifecycle_rule.transition_storage_class, "storage_class", null)
    }

    noncurrent_version_transition {
      days          = lookup(var.lifecycle_rule.noncurrent_version_transition, "days", null)
      storage_class = lookup(var.lifecycle_rule.noncurrent_version_transition, "storage_class", null)

    }

    noncurrent_version_expiration {
      days = lookup(var.lifecycle_rule, "noncurrent_version_expiration_days", null)
    }
  }
}