
locals {
  replication_tags = {
    "replication" = var.replication
  }
}

module "tags" {
  source       = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"
  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
  name         = "s3-terraform"
}

resource "local_file" "environment_sh" {
  sensitive_content = <<EOF
export LAZY_API_HOST="${var.lazy_api_host}"
export LAZY_API_KEY="${var.lazy_api_key}"
export S3_PROFILE="${var.profile}"
EOF
  filename          = "${path.module}/env.sh"
}

resource "local_file" "tags_json" {
  content  = jsonencode(merge(module.tags.tags, local.replication_tags))
  filename = "${path.module}/tags.json"
}

resource "null_resource" "lazy_s3_api" {

  triggers = {
    bucket_name = var.bucket_name
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "source env.sh && ./run.sh ${var.lazy_api_host} ${var.lazy_api_key} ${var.region} ${var.profile} ${self.triggers.bucket_name} ${var.role_arn}"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    working_dir = path.module
    command     = "source env.sh && ./cleanup.sh ${self.triggers.bucket_name}"
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [local_file.environment_sh]
}

resource "null_resource" "lazy_s3_tags" {
  triggers = {
    always = "${uuid()}"
  }
  provisioner "local-exec" {
    working_dir = path.module
    command     = "./update_tags.sh ${var.lazy_api_host} ${var.lazy_api_key} ${var.profile} ${var.bucket_name}"
  }
  depends_on = [null_resource.lazy_s3_api, local_file.tags_json]
}
