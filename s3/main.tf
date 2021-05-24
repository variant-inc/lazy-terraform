
resource "null_resource" "lazy_s3_api" {

  triggers = {
    bucket_name = var.bucket_name
  }

  provisioner "local-exec" {
    working_dir = path.module
    command = "./run.sh ${var.lazy_api_host} ${var.lazy_api_key} ${var.region} ${var.profile} ${self.triggers.bucket_name} ${var.owner} ${var.purpose} ${var.team} ${var.octopus_project_space} ${var.octopus_project_name}"
  }
}