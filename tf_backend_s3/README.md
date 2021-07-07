# Terraform S3 State Backend

Module to create s3, dynamodb & KMS for terraform s3 backend

## Input Variables

 | Name          | Type   | Default                                  | Example             | Notes |
 | ------------- | ------ | ---------------------------------------- | ------------------- | ----- |
 | region        | string | us-east-1                                |                     |       |
 | name          | string |                                          | test-123            |       |
 | lazy_api_host | string | <https://lazy.apps.ops-drivevariant.com> |                     |       |
 | lazy_api_key  | string |                                          | `octopus populated` |       |
 | user_tags     | object |                                          | `see below`         |       |
 | octopus_tags  | object |                                          | `see below`         |       |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```

## Example tf

[Example](./tests/main.tf)

```bash
module "test_s3_module" {
  source = "../"

  profile = "devops"
  region  = "us-east-1"
  name    = "test-ops-39"

  user_tags = {
    team    = "devops2"
    purpose = "s3-test3"
    owner   = "naveen3"
  }

  # If run from octopus, this will be auto set
  lazy_api_key  = var.lazy_api_key
  lazy_api_host = var.lazy_api_host
  octopus_tags  = var.octopus_tags
  role_arn      = var.role_arn
}
```
