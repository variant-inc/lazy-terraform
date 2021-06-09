# Lazy S3 Module

Module to create s3 bucket

## Input Variables

 | Name                         | Type          | Default             | Example           |    Notes           |
 | ---------------------------- | ------------- | ------------------- | ----------------- | -----------------  |
 | region                       | string        |                     |                   |                    |
 | profile                      | string        |                     |                   |                    |
 | bucket_name                  | string        |                     |                   |                    |
 | lazy_api_host                | string        | "https://lazy.apps.ops-drivevariant.com"  |                    | auto set at octopus|
 | lazy_api_key                 | string        |                     |                   |auto set at octopus |
 | role_arn                     | string        |      ""             |                   |                    |
 | user_tags                    | object        |                     |user_tags = {team = "devops4" purpose = "s3-test3" owner = "naveen3"}| For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>   |
 | octopus_tags                 | object        |                     | octopus_tags = { project = "actions-test3" space = "Default3"}| auto set at octopus|
 | replication                  | string        |  false              |                   |                    |

Tags module expect to have project and space in octopus tags but this is not mandatory if it is being run from octopus, they will get auto set.

variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}

## Example .tfvars

```bash
profile = "devops"
region = "us-west-2"
bucket_name = "navin-ops-11"
lazy_api_host = "https://lazy.apps.ops-drivevariant.com"
lazy_api_key = "####################"
user_tags = {
team = "devops4"
purpose = "s3-test3"
owner = "naveen3"
}
octopus_tags = {
project = "actions-test3"
space   = "Default3"
}
replication=true
```

## Example .tf file module reference

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
variable "lazy_api_host" {
  type = string
}

variable "lazy_api_key" {
  type = string
  sensitive = true
}

variable "user_tags" {
  description = "User tags"
  type = map(string)
}

module "test_s3_module" {
    source = "git::https://github.com/variant-inc/lazy-terraform.git//s3?ref=v1"
        profile = "devops"
        region = "us-west-2"
        bucket_name = "navin-ops-39"
        lazy_api_key = var.lazy_api_key # If run from octopus, this will be auto set
        lazy_api_host = var.lazy_api_host # If run from octopus, this will be auto set
        user_tags = var.user_tags
        octopus_tags = var.octopus_tags # If run from octopus, this will be auto set
        replication=true
}
```
