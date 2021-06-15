# Lazy Amazon MQ Module

Module to deploy Amazon MQ broker where supported engine type is RabbitMQ
Assumptions:
- Amazon MQ will be created as a public broker until communicaiton with USXIT is established
- Once established Private VPC portion needs to be implemented

## Resources

- Amazon MQ Broker (RabbitMQ)
- Security Groups
- Subnets
- Tags

## Input Variables

| Name                      | Description                         | Type   | Default   | Example          |
| -----------               | ----------------------------------- | ------ | --------- | ---------------- |
| profile                   | AWS Profile Name                    | string | us-east-1 | us-west-2        |
| user_tags                 | User Tags                           | object |           | `see below`    |
| octopus_tags              | User Tags                           | object |           | `see below`    |
| broker_name               | RabbitMQ Broker Name                | string |           | my-rabbitmq      |
| engine_version            | RabbitMQ Engine Version             | string | 3.8.11    | Supported versions can be found at <https://amzn.to/3pjVBt5> |
| broker_instance_type      | RabbitMQ Broker Instance Type       | string | mq.m5.large| Supported instance types are <https://amzn.to/2RkkiZT> |
| username                  | RabbitMQ Username                   | string | rmqadmin   | rmqadmin |
| auto_minor_version_upgrade| Flag for auto minor version upgrade | boolean | true   | true / false |
| deployment_mode           | RabbitMQ Deployment Mode            | string | CLUSTER_MULTI_AZ   | one of: "SINGLE_INSTANCE", "CLUSTER_MULTI_AZ", "ACTIVE_STANDBY_MULTI_AZ" |
| cloudwatch_general_logs   | Flag to enable CloudWatch logs      | boolean | false   | true / false                                                                                                           |
| maintenance_window        | Maintenance Window                  | object |           | `see below`    |
| inbound_cidrs             | Inbound CIDS for SG                 | string | 0.0.0.0/0          |     |
| maintenance_window        | Maintenance Window                  | object |           | `see below`    |
| publicly_accessible       | To set if RMQ is publicly accessible| boolean | false          | true / false    |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```
For `maintenance_window`, pass input as below

```bash
  {
      day_of_week = "SUNDAY"
      time_of_day = "05:00"
  }
```
Region will be picked up from the environment variable AWS_DEFAULT_REGION


## Output Variables

| Name | Description | Type | Example |
| - | - | - | - |
| broker_amqp_endpoint | Endpoint for connecting via AMQP client | string | amqps://b-be41287c-8d63-4c31-87a6-8a8e728fbea7.mq.us-east-1.amazonaws.com:5671 |
| broker_console_endpoint | HTTP Endpoint for administration console | string | https://b-be41287c-8d63-4c31-87a6-8a8e728fbea7.mq.us-east-1.amazonaws.com    |
| broker_user | Root username | string | rmqadmin |
| broker_aws_secret_name | Name of secret which contains root password to be retrieved from AWS Secrets Manager | string | eng-track-and-trace-amq-password |


## Example minimum.tfvars
This example shows the minimum set of variables required to create Amazon MQ broker of type RabbitMQ. This include default values for variables not specified

```bash
broker_name                = "mq-test-broker"
broker_instance_type       = "mq.m5.2xlarge"
username                   = "mqtestadmin"
auto_minor_version_upgrade = true
deployment_mode            = "CLUSTER_MULTI_AZ"
broker_purpose             = "mq-test"
broker_owner               = "mq-test-tf"
user_tags = {
  team    = "devops"
  purpose = "rabbitmq module test"
  owner   = "sandeep"
}
```
