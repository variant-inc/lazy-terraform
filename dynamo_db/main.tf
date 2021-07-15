module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
  name         = "dynamodb-terraform"
}

locals {
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
}

resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  read_capacity  = local.read_capacity
  write_capacity = local.write_capacity
  hash_key       = var.hash_key
  range_key      = var.range_key

  dynamic "attribute" {
    for_each = var.attributes == null ? [] : var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes == null ? [] : var.global_secondary_indexes
    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.value.name
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes == null ? [] : var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }


  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = module.tags.tags

}
