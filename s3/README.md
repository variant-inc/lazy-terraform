# Lazy S3 Module

Module to create s3 bucket

## Features

- Create S3 Bucket
- Update Tags
- Delete S3 Bucket

## Limitations

- Lifecycle policies aren't supported yet

## Input Variables

 | Name               | Type   | Default                                  | Example                               | Notes                                         |
 | ------------------ | ------ | ---------------------------------------- | ------------------------------------- | --------------------------------------------- |
 | region             | string | us-east-1                                |                                       |                                               |
 | bucket_prefix      | string |                                          | test-1                                | Either this or `bucket_name` is required      |
 | bucket_prefix      | string |                                          | test-123-asda                         |                                               |
 | lazy_api_host      | string | <https://lazy.apps.ops-drivevariant.com> |                                       | auto set at octopus                           |
 | lazy_api_key       | string |                                          |                                       | auto set at octopus                           |
 | aws_role_to_assume | string |                                          | arn:aws:iam::108141096600:role/tf-rds |                                               |
 | env                | string | non-prod                                 | prod                                  | `prod` will support replication in the future |
 | user_tags          | object |                                          | `see below`                           |                                               |
 | octopus_tags       | object |                                          | `see below`                           | auto set at octopus                           |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```

## Examples

Refer here [Link](./tests/main.tf)

Use the following for source

```bash
source = "github.com/variant-inc/lazy-terraform//rds?ref=v1"
```
