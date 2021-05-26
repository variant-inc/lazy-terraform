
provider "aws" {
    region     = var.region
    profile = var.profile
}
terraform {
  required_version = "~> 0.14.0"
    backend s3 {
    profile         = "108141096600_AWSAdministratorAccess"
    bucket          = "lazy-tf-state20210107203535113800000001"
    key             = "dynamodb/default1"
    region          = "us-west-2"
    dynamodb_table  = "lazy_tf_state"
    encrypt         = false
  }
}