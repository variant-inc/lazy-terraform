# Lazy DynamoDB Module

Module to create dynamo db table using lazy terraform scripts

## Input Variables

<!-- markdownlint-disable MD013 MD033 -->

| Name                          | Type            | Description                                                                  | Default Value | Example                           |
| ----------------------------- | --------------- | ---------------------------------------------------------------------------- | --------------| ----------------                  |
| profile                       | string          | Environment where table need to be created                                   |               | prod, devops, dev                 |
| user_tags                     |   object({team = string purpose = string owner   = string }) | Mandatory user tags             |               |                                   |
| octopus_tags                  | object({ project = string space   = string })          | octopus tags                          |               |                                   |
| billing_mode                  | string          | Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST.              | PAY_PER_REQUEST|                                  |
| hash_key                      | string          | The attribute to use as the hash (partition) key. Must also be defined as an attribute                                                                |               |                                       |
| hash_key_type                 | string          | hash key type , valid values S, N and B                                      |                  | "S", "N", "B"                   |
| range_key                     | string          | The attribute to use as the range (sort) key. Must also be defined as an attribute          |        null          |              |
| table_name                    | string          | Name of the DynamoDB table                                                   |                |                                   |
| attributes                    | list(object({ name = string, type = string }))          | List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data                                                   |    null            |           attributes = [ { name = "Name", type = "S",  }, { name = "Age", type = "N" }]                                |
| global_secondary_indexes      | any             | GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc. Maximum of 5 global secondary indexes can be defined for the table                                      |     null             |   global_secondary_indexes = [ { name = "UserTitleIndex" hash_key = "UserId" range_key = "Name" write_capacity = 10 read_capacity = 10 projection_type = "INCLUDE"  non_key_attributes = ["UserId"]}  ]                   |
| local_secondary_indexes       | any             | LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource, maximum of 5 global secondary indexes can be defined for the table                                      |       null           |         local_secondary_indexes = [{ name = "customerId-city-index" range_key          = "Name" projection_type    = "ALL"  # ALL, INCLUDE or KEYS_ONLY non_key_attributes = [] } ]                   |
| read_capacity                 | string          | (Optional) The number of read units for this table. If the billing_mode is PROVISIONED, this field is required.                                    |    2              |                   |
| write_capacity                 | string          | (Optional) The number of write units for this table. If the billing_mode is PROVISIONED, this field is required.                                      |        2          |                   |
<!-- markdownlint-enable MD013 MD033 -->

In case if it fails for region in any of the below testing, please run below command in your local

```bash
export AWS_DEFAULT_REGION=us-west-2 to set the region
```

## Example .tfvars without indexes

```bash
profile = "133444455555_AWSAdministratorAccess"
user_tags = {
  team = "devops"
  purpose = "dynamo"
  owner = "naveen"
  }
octopus_tags = {
  project = "actions-test"
  space   = "Default"
}
table_name = "naveen-ops-11"
#Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST."
billing_mode = "PAY_PER_REQUEST"
# billing_mode = "PROVISIONED"
# read_capacity = 2
# write_capacity =2
hash_key = "UserId"
hash_key_type = "S"

#if you have a range key, add it to below attributes section, can also be used to add any non-key attributes. Attributes section can be skipped, if you don't have range key or any non-key attributes.
range_key = "Name"
attributes = [
    {
      name = "Name",
      type = "S",
    }
  ]
```

## Example .tfvars with indexes

```bash
profile = "133444455555_AWSAdministratorAccess"
user_tags = {
  team = "devops"
  purpose = "dynamo"
  owner = "naveen"
  }
octopus_tags = {
  project = "actions-test"
  space   = "Default"
}
table_name = "naveen-ops-11"
#Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST."
billing_mode = "PAY_PER_REQUEST"
# billing_mode = "PROVISIONED"
# read_capacity = 2
# write_capacity =2
hash_key = "UserId"
hash_key_type = "S"

#if you have a range key, add it to below attributes section, can also be used to add any non-key attributes. Attributes section can be skipped, if you don't have range key or any non-key attributes.
range_key = "Name"
attributes = [
    {
      name = "Name",
      type = "S",
    },
        {
      name = "Age",
      type = "N",
    }
  ]

# sample global_secondary_indexes
# This is not mandatory , if you want indexing on your table, this is how you can pass the input
global_secondary_indexes = [
  {
    name               = "UserTitleIndex"
    hash_key           = "UserId"
    range_key          = "Name"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  },
  {
    name               = "AgeIndex"
    hash_key           = "UserId"
    range_key          = "Age"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["Name"]
  }
]
# sample local_secondary_indexes
# This is not mandatory , if you want local secondary indexes on your table, this is how you can pass the input
local_secondary_indexes = [
{
    name               = "name-index"
    range_key          = "Name"
    projection_type    = "ALL"  # ALL, INCLUDE or KEYS_ONLY
    non_key_attributes = []
  }]
```

## To test as module

```bash
module "dynamodb_table" {
  source = "git::https://github.com/variant-inc/lazy-terraform.git//dynamo_db?ref=v1"
  #If testing on branch
  # source = "git::https://github.com/variant-inc/lazy-terraform.git//dynamo_db?ref=feature/CLOUD-272-module-for-dynamo-db"

    profile = "108141096600_AWSAdministratorAccess"
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
  