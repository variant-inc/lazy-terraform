
terraform {
  backend "s3" {
    profile         = "iaac_ops"
    bucket          = ""
    key             = "s3/default"
    region          = "us-west-2"
    dynamodb_table  = "lazy_tf_state"
    encrypt         = true
    kms_key_id      = ""
  }
}

resource "null_resource" "lazy_s3_api" {

  triggers = {
    s3_region = var.s3_region
    s3_profile = var.s3_profile
    s3_bucket_name = var.s3_bucket_name
    owner = var.owner
    purpose = var.purpose
    team = var.team
    lazy_api_host = var.lazy_api_host
    lazy_api_key = var.lazy_api_key
  }

 provisioner "local-exec" {
    command = "cd ${path.module}/s3 && ./run.sh ${self.triggers.lazy_api_host} ${self.triggers.lazy_api_key} ${self.triggers.region} ${self.triggers.s3_profile} ${self.triggers.s3_bucket_name} ${self.triggers.owner} ${self.triggers.purpose} ${self.triggers.team}"
  }

 provisioner "local-exec" {
    when        = destroy
    command = "cd ${path.module}/s3 && ./cleanup.sh ${self.triggers.lazy_api_host} ${self.triggers.lazy_api_key} ${self.triggers.s3_profile} ${self.triggers.s3_bucket_name}"
  }
}
