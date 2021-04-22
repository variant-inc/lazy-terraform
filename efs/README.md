# Octopus Server EFS Module

Module to update Octopus EFS volumes

## Input Variables

| Name        | Description                           | Type   | Default   | Example          |
| ----------- | ------------------------------------- | ------ | --------- | ---------------- |
| vpc_id      | ID of VPC where efs has to be created | string |           | vpc-000000000000 |
| volume_name | Friendly name of the efs volume       | string |           | DP               |
| tag_purpose | Purpose Tag                           | string |           | This is an efs   |
| tag_team    | Team Tag                              | string |           | DevOps           |
| tag_owner   | Owner Tag                             | string |           | Vibin            |
| profile     | AWS Profile Name                      | string | default   | dev              |
| region      | AWS Region                            | string | us-east-1 | us-west-2        |

## Example .tfvars

```text
vpc_id = "vpc-000000000000"
volume_name = "DP"
tag_purpose = "This is an efs"
tag_team = "DevOps"
tag_owner = "Vibin"
```
