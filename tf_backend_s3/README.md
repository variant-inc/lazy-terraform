# Terraform S3 State Backend

Module to create s3, dynamodb & KMS for terraform s3 backend

## Input Variables

 | Name          | Type   | Default                                  | Example             | Notes |
 | ------------- | ------ | ---------------------------------------- | ------------------- | ----- |
 | region        | string | us-east-1                                |                     |       |
 | table_name    | string |                                          | test_123            |       |
 | bucket_prefix | string |                                          | test-bucket         |       |
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

Use the following for source

```bash
source = "github.com/variant-inc/lazy-terraform//rds?ref=v1"
```
