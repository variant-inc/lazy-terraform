terraform {
  backend "s3" {
    profile         = "iaac_ops"
    bucket          = ""
    key             = "vpc/default"
    region          = "us-west-2"
    dynamodb_table  = "lazy_tf_state"
    encrypt         = true
    kms_key_id      = ""
  }
}

provider "aws" {
  region = var.region
  profile = var.aws_profile
}