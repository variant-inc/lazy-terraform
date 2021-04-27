resource "null_resource" "lazy_s3_api" {

  triggers = {
    region = var.region
    profile = var.profile
    s3_bucket_name = var.s3_bucket_name
    owner = var.owner
    purpose = var.purpose
    team = var.team
    lazy_api_host = var.lazy_api_host
    lazy_api_key = var.lazy_api_key
  }

 provisioner "local-exec" {
    command = "ls -a && chmod +x run.sh && ./run.sh ${self.triggers.lazy_api_host} ${self.triggers.lazy_api_key} ${self.triggers.region} ${self.triggers.profile} ${self.triggers.s3_bucket_name} ${self.triggers.owner} ${self.triggers.purpose} ${self.triggers.team}"
  }

 provisioner "local-exec" {
    when        = destroy
    command = " chmod +x cleanup.sh && ./cleanup.sh ${self.triggers.lazy_api_host} ${self.triggers.lazy_api_key} ${self.triggers.profile} ${self.triggers.s3_bucket_name}"
  }
}
