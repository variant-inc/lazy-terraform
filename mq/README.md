# Lazy Amazon MQ Module

Module to deploy Amazon MQ broker where supported engine type is RabbitMQ
Assumptions:
- Amazon MQ will be created as a public broker until communicaiton with USXIT is established
- Once established Private VPC portion needs to be implemented

## Resources

- Amazon MQ Broker (RabbitMQ)

## Input Variables

- region
  - string
  - default = "us-east-1"
- profile
  - string
- broker_name
  - string
- engine_type
  - default = "RabbitMQ"
- engine_version
  - string
  - default = "3.8.11"
  - supported versions can be found at https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html#rabbitmq-broker-engine
- broker_instance_type
  - string
  - default = "mq.m5.large"
  - supported instance types for RabbitMQ can be found at https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-instance-types.html#rabbitmq-broker-instance-types
- username
  - string
  - default = rmqadmin
- password
  - string
- auto_minor_version_upgrade
  - boolean
  - default = false
- deployment_mode
  - string
  - default = "CLUSTER_MULTI_AZ"
  - one of: "SINGLE_INSTANCE", "CLUSTER_MULTI_AZ", "ACTIVE_STANDBY_MULTI_AZ"
- cloudwatch_general_logs
  - boolean
  - default = true
- day_of_week
  - string
  - one of: "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"
- time_of_day
  - string
  - default = "05:00"
  - should be in 24 hour format "HH:MM"
- time_zone
  - string
  - default = "UTC"
  - should be valid TZ database name column from https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
- broker_purpose
  - string
  - default = "broker-purpose-not-provided"
- broker_owner
  - string
  - default = "broker-owner-not-provided"


## Example 1 minimum.tfvars
## This example shows the minimum set of variables required to create Amazon MQ broker of type RabbitMQ. This include default values for variables not specified
## To test plan use "terraform plan -var-file=minimum.tfvars -out=minimum.out
## To apply use "terraform apply "minimum.out"

```bash
profile = "dev-ops"
region = "us-west-2"
broker_name = "mq-test-broker"
broker_instance_type = "mq.m5.2xlarge"
username = "mqtestadmin"
auto_minor_version_upgrade = true
deployment_mode = "CLUSTER_MULTI_AZ"
broker_purpose = "mq-test"
broker_owner = "mq-test-tf"
```

## Example 2 alternative.tfvars
## This example shows the alternative set of variables used to create Amazon MQ. This also includes some variables where default values are overriden
## To test plan use "terraform plan -var-file=alternative.tfvars -out=alternative.out
## To apply use "terraform apply "alternative.out"

```bash
profile = "dev-ops"
region = "us-west-2"
broker_name = "mq-alternative-test-broker"
engine_version = "3.8.11"
broker_instance_type = "mq.m5.4xlarge"
username = "mqtestadmin"
auto_minor_version_upgrade = true
deployment_mode = "CLUSTER_MULTI_AZ"
cloudwatch_general_logs = false
day_of_week = "SATURDAY"
time_of_day = "10:00"
time_zone = "CET"
broker_purpose = "mq-alternative-test"
broker_owner = "mq-alternative-tf"
```
## Output Variables

- broker_arn
  - string
- broker_id
  - string
- broker_url
  - string