# Lazy Amazon Kinesis Firehose Module

Module to deploy Amazon Kinesis Firehose Module where destination is extended_s3

Assumptions:
- Firehose stream is encrypted at REST where key_type is AWS_OWNED_CMK 
- Firehose destination is extended_s3
- Input is via PUT object

## Resources

- Amazon Firehose Stream
- Amazon S3
- Amazon Lambda
- Associated Roles with inline policies

## Input Variables

| Name                      | Description                         | Type   | Default   | Example          |
| -----------               | ----------------------------------- | ------ | --------- | ---------------- |
| profile                   | AWS Profile Name                    | string | us-east-1 | us-west-2        |
| user_tags                 | User Tags                           | object |           | `see below`    |
| octopus_tags              | User Tags                           | object |           | `see below`    |
| kinesis_firehose_delivery_stream | Firehose Delivery Stream Name            | string |           | my-firehose-stream |
| firehose_s3        | Configurable values for firehose s3 bucket             | object |           | `see below`    |
| firehose_lambda    | Configurable values for firehose s3 lambda processor   | object |           | `see below`    |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```
For `firehose_s3`, pass input as below

```bash
  {
    buffer_size = 1
    buffer_interval = 60
    bucket_content_prefix = null
    bucket_content_error_prefix = null
  }
```

For `firehose_lambda`, pass input as below

```bash
  {
    filename = "lambda.zip"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.8"
    timeout = 60
    memory_size = 1024
  }
```
Lambda filename should be uploaded in .zip format

Region will be picked up from the environment variable AWS_DEFAULT_REGION

## Example minimum.tfvars
This example shows the minimum set of variables required to create Amazon Kinesis Firehose with extended S3 configuration

```bash
kinesis_firehose_delivery_stream = "terraform-firehose-stream"
firehose_lambda = {
  filename = "lambda.zip"
  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"
  timeout = 60
  memory_size = 1024
}
user_tags = {
  team    = "devops"
  purpose = "firehose module test"
  owner   = "sandeep"
}
```
