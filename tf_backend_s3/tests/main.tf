terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

provider "aws" {}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "create_vars_bucket" {
  description = "Create Vars Bucket"
  type        = bool
  default     = false
}

module "tf_backend" {
  source = "../"

  region        = "us-east-1"
  table_name    = "test-ops"
  bucket_prefix = "test-ops"

  user_tags = {
    team    = "devops2"
    purpose = "s3-test3"
    owner   = "naveen3"
  }

  # If run from octopus, this will be auto set
  octopus_tags       = var.octopus_tags
  create_vars_bucket = var.create_vars_bucket
}
