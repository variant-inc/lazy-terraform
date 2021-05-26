# Lazy S3 Module

Module to create s3 bucket

## Input Variables

- region
  - string
- profile
  - string
- bucket_name
  - string
- purpose
  - string
- owner
  - string
- team
  - string
- lazy_api_host
  - string
  - default = "https://lazy.apps.ops-drivevariant.com"
- lazy_api_key
  - string
- octopus_project_space
  - string
- octopus_project_name
  - string

## Example .tfvars

```bash
profile = "devops"
region = "us-west-2"
bucket_name = "naveen-ops-1"
purpose = "devops"
team = "devops"
owner = "devops"
lazy_api_host = "https://lazy.apps.ops-drivevariant.com"
lazy_api_key = "add_lazy_api_key_here"
bucket = "lazy-tf-state20210107203535113800000001"
key = "s3/default"
dynamodb_table = "lazy_tf_state"
s3_backend_region = "us-west-2"
octopus_project_space = "test-space"
octopus_project_name = "test-project"
role_arn = "arn:aws:iam::123456789013:role/role_name"
```
