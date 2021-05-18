
terraform {
  backend "s3" {
    profile         = "108141096600_AWSAdministratorAccess"
    bucket          = "lazy-tf-state20210107203535113800000001"
    key             = "s3/default"
    region          = "us-west-2"
    dynamodb_table  = "lazy_tf_state"
    encrypt         = true
    kms_key_id      = "arn:aws:kms:us-west-2:108141096600:key/fc9bb6d7-4f0d-4b99-a830-85951933c030"
  }
}

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
    command = "./run.sh ${self.triggers.lazy_api_host} ${self.triggers.lazy_api_key} ${self.triggers.region} ${self.triggers.profile} ${self.triggers.bucket_name} ${self.triggers.owner} ${self.triggers.purpose} ${self.triggers.team} ${self.triggers.octopus_project_space} ${self.triggers.octopus_project_name}"
  }

 provisioner "local-exec" {
    when        = destroy
    command = "./cleanup.sh ${self.triggers.lazy_api_host} ${self.triggers.lazy_api_key} ${self.triggers.s3_profile} ${self.triggers.s3_bucket_name}"
  }
}
