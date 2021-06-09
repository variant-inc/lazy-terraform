terraform {
    required_version = "~> 0.15.0"
  backend "s3" {
    profile         = "108141096600_AWSAdministratorAccess"
    bucket          = "lazy-tf-state20210107203535113800000001"
    key             = "s3/default9"
    region          = "us-west-2"
    dynamodb_table  = "lazy_tf_state"
    encrypt         = false
  }
}
