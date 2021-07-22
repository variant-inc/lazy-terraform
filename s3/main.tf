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

resource "local_file" "env_file" {
  sensitive_content = <<EOF
$LAZY_API_HOST = "${var.lazy_api_host}"
$LAZY_API_KEY = "${var.lazy_api_key}"
$BUCKET_NAME ="${local.name}"
$AWS_ROLE_TO_ASSUME ="${var.aws_role_to_assume}"
$AWS_REGION ="${var.region}"
$TAGS = '${local.tags}'
EOF
  filename          = "${path.module}/env/env.ps1"
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
    bucket_name        = local.name
    aws_role_to_assume = var.aws_role_to_assume
    region             = var.region
  }

  provisioner "local-exec" {
    working_dir = path.module
    interpreter = ["pwsh", "-c"]

    command = "./scripts/create.ps1"
  }

  provisioner "local-exec" {
    when        = destroy
    working_dir = path.module
    interpreter = ["pwsh", "-c"]

    command = "./scripts/delete.ps1"
  }
  depends_on = [local_file.env_file]
}

resource "null_resource" "s3_update_tags" {
  triggers = {
    tags  = local.tags
    dummy = uuid()
  }
  provisioner "local-exec" {
    working_dir = path.module
    interpreter = ["pwsh", "-c"]

    command = "./scripts/tags.ps1"
  }
  depends_on = [null_resource.s3_create_delete, local_file.env_file]
}
