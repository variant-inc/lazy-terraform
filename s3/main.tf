locals {
  replication_tags = {
    replication = var.env == "prod"
  }

  name = var.bucket_name != "" ? var.bucket_name : "${var.bucket_prefix}-${random_string.random.result}"
  tags = jsonencode(merge(module.tags.tags, local.replication_tags))
}

module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  name = local.name

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
}

resource "random_string" "random" {
  length      = 16
  special     = false
  lower       = true
  upper       = false
  min_numeric = 3
}

resource "null_resource" "s3_create_delete" {
  triggers = {
    bucket_name = local.name
    region      = var.region
  }

  provisioner "local-exec" {
    working_dir = path.module
    interpreter = ["pwsh", "-c"]

    command = "./scripts/create.ps1 -BUCKET_NAME ${self.triggers.bucket_name} -AWS_REGION ${self.triggers.region}"
  }

  provisioner "local-exec" {
    when        = destroy
    working_dir = path.module
    interpreter = ["pwsh", "-c"]

    command = "./scripts/delete.ps1 -BUCKET_NAME ${self.triggers.bucket_name}"
  }
}

resource "null_resource" "s3_update_tags" {
  triggers = {
    bucket_name = local.name
    region      = var.region
    tags        = local.tags
    dummy       = uuid()
  }
  provisioner "local-exec" {
    working_dir = path.module
    interpreter = ["pwsh", "-c"]

    command = "./scripts/tags.ps1 -BUCKET_NAME ${self.triggers.bucket_name} -AWS_REGION ${self.triggers.region} -TAGS '${self.triggers.tags}'"
  }
  depends_on = [null_resource.s3_create_delete]
}
