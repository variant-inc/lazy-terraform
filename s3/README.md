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

To test locally, you need to have powershell & curl installed and the following env variables set to appropriate values

1. LAZY_API_HOST
2. LAZY_API_KEY
3. AWS_ROLE_TO_ASSUME

## Examples

Refer here [Link](./tests/main.tf)

Use the following for source

```bash
source = "github.com/variant-inc/lazy-terraform//rds?ref=v1"
```
