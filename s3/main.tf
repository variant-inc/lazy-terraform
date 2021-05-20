resource "null_resource" "lazy_s3_api" {

  triggers = {
    region = var.region
    profile = var.profile
    bucket_name = var.bucket_name
    owner = var.owner
    purpose = var.purpose
    team = var.team
    lazy_api_host = var.lazy_api_host
    lazy_api_key = var.lazy_api_key
    octopus_project_space = var.octopus_project_space
    octopus_project_name = var.octopus_project_name
  }

 provisioner "local-exec" {
    working_dir = path.module
    command = "./run.sh ${self.triggers.lazy_api_host} ${self.triggers.lazy_api_key} ${self.triggers.region} ${self.triggers.profile} ${self.triggers.bucket_name} ${self.triggers.owner} ${self.triggers.purpose} ${self.triggers.team} ${self.triggers.octopus_project_space} ${self.triggers.octopus_project_name}"
  }

 provisioner "local-exec" {
    when        = destroy
    working_dir = path.module
    command = "./cleanup.sh ${self.triggers.lazy_api_host} ${self.triggers.lazy_api_key} ${self.triggers.profile} ${self.triggers.bucket_name}"
  }
}
