# Terraform S3 Bucket

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

terraform.tfvars.

```json
{
    "bucket_prefix":"test-ralph",
    "lifecycle_rule":{
       "prefix":"config/",
       "enabled":true,
       "abort_incomplete_multipart_upload_days":30,
       "transition_storage_class":"STANDARD_IA",
       "noncurrent_version_transition":{
          "days":60,
          "storage_class":"GLACIER"
       },
       "noncurrent_version_expiration_days:": 90
    },
    "user_tags": {
        "team": "devops",
        "purpose": "dms-testing",
        "owner": "devops"
      },
      "octopus_tags": {
        "project": "n/a",
        "space": "DevOps",
        "environment": "dpl",
        "project_group": "n/a",
        "release_channel": "n/a"
      }
 }
```

## Examples

Refer here [Link](./tests/main.tf)
