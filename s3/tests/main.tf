terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "lazy_api_host" {
  type = string
}

variable "lazy_api_key" {
  type      = string
  sensitive = true
}

variable "aws_role_to_assume" {
  type = string
}

module "test_s3_module" {
  source = "../"

  profile       = "devops"
  region        = "us-west-2"
  bucket_name   = "navin-ops-39"
  lazy_api_key  = var.lazy_api_key  # If run from octopus, this will be auto set
  lazy_api_host = var.lazy_api_host # If run from octopus, this will be auto set
  user_tags = {
    team    = "devops2"
    purpose = "s3-test3"
    owner   = "naveen3"
  }
  octopus_tags = var.octopus_tags # If run from octopus, this will be auto set
  replication  = true
  role_arn     = var.aws_role_to_assume # If run from octopus, this will be auto set
}
