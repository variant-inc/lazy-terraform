# Terraform S3 State Backend

Module to create s3, dynamodb & KMS for terraform s3 backend

## Input Variables

- profile
  - string
- region
  - string
- environment
  - string
- dynamodb_table_name
  - string
- replica_bucket_prefix
  - string
- state_bucket_prefix
  - string

## Example .tfvars

```text
{
  "name": "data-tf",
  "user_tags": {
    "purpose": "TF for data",
    "team": "cloudops",
    "owner": "cloudops"
  },
  "octopus_tags": {
    "project": "n/a",
    "space": "n/a"
  },
  "lazy_api_key": "",
  "profile": "prod"
}
```
