# Lazy DynamoDB Module

Module to create dynamo db table using lazy terraform scripts

## Input Variables


| Name                     | Type                                           | Default Value   | Example           |
| ------------------------ | ---------------------------------------------- | --------------- | ----------------- |
| profile                  | string                                         |                 | prod, devops, dev |
| user_tags                | map(string)                                    |                 |                   |
| octopus_tags             | map(string)                                    |                 |                   |
| billing_mode             | string                                         | PAY_PER_REQUEST |                   |
| hash_key                 | string                                         |                 |                   |
| hash_key_type            | string                                         |                 | "S", "N", "B"     |
| range_key                | string                                         | null            |                   |
| table_name               | string                                         |                 |                   |
| attributes               | list(object({ name = string, type = string })) | null            |                   |
| global_secondary_indexes | any                                            | null            |                   |
| local_secondary_indexes  | any                                            | null            |                   |
| read_capacity            | string                                         | 2               |                   |
| write_capacity           | string                                         | 2               |                   |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```

In case if it fails for region in any of the below testing, please run below command in your local

```bash
export AWS_DEFAULT_REGION=us-west-2 to set the region
```
## To test as module

```bash
module "dynamodb_table" {
  source = "github.com/variant-inc/lazy-terraform//dynamo_db?ref=v1"
    table_name = "naveen-new-12"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "UserId"
    hash_key_type = "S"
    user_tags = {
      team = "devops"
      purpose = "dynamo"
      owner = "naveen"
      }
    octopus_tags = {
      project = "actions-test"
      space   = "Default"
    }

    range_key = "Name"
    attributes = [
        {
        name = "Name",
        type = "S",
        }
    ]
}

```

## Output Variables

- aws_dynamodb_table.table
  - string
  