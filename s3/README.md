# Lazy S3 Module

Module to create s3 bucket

## Features

This module internally uses null resource to invoke lazy s3 api's to create bucket also has ability to update the tags after the bucket is created.

When terraform destroy is run it internally calls lazy s3 delete endpoint for bucket deletion.

## Limitations

When bucket name is changed after s3 bucket is created, terraform will try to delete the bucket and will create a new bucket.

Any other attributes changed other than bucket name and tags will not take any affect.

## Input Variables

 | Name          | Type   | Default                                  | Example                               | Notes               |
 | ------------- | ------ | ---------------------------------------- | ------------------------------------- | ------------------- |
 | region        | string |                                          |                                       |                     |
 | profile       | string |                                          |                                       |                     |
 | bucket_name   | string |                                          |                                       |                     |
 | lazy_api_host | string | <https://lazy.apps.ops-drivevariant.com> |                                       | auto set at octopus |
 | lazy_api_key  | string |                                          |                                       | auto set at octopus |
 | role_arn      | string |                                          | arn:aws:iam::108141096600:role/tf-rds |                     |
 | user_tags     | object |                                          | `see below`                           |                     |
 | octopus_tags  | object |                                          | `see below`                           | auto set at octopus |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```


## Example .tf file module reference

```bash
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
  source        = "git::https://github.com/variant-inc/lazy-terraform.git//s3?ref=v1"
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
```
