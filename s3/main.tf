
resource "local_file" "environment_sh" {
    sensitive_content = <<EOF
export LAZY_API_HOST="${var.lazy_api_host}"
export LAZY_API_KEY="${var.lazy_api_key}"
export S3_PROFILE="${var.profile}"
EOF
    filename = "${path.module}/env.sh"
}

resource "null_resource" "lazy_s3_api" {

  triggers = {
    bucket_name = var.bucket_name
  }

  provisioner "local-exec" {
    working_dir = path.module
    command = "source env.sh && ./run.sh ${var.lazy_api_host} ${var.lazy_api_key} ${var.region} ${var.profile} ${self.triggers.bucket_name} ${var.owner} ${var.purpose} ${var.team} ${var.octopus_project_space} ${var.octopus_project_name} ${var.role_arn}"
  }

   provisioner "local-exec" {
    when        = destroy
    working_dir = path.module
    command = "source env.sh && ./cleanup.sh ${self.triggers.bucket_name}"
  }
  depends_on = [ local_file.environment_sh]
}





