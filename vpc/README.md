# Terraform VPC Setup Module

This module create a VPC with private and public subnets

## Input Variables

| Name         | Type   | Default Value                                  | Example      |
| ------------ | ------ | ---------------------------------------------- | ------------ |
| name         | string | default                                        |              |
| cidr         | string |                                                | 10.10.0.0/20 |
| user_tags    | object |               | `see below` |
| octopus_tags | object |               | `see below` |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```

## Example .tfvars

```text
cidr = "10.1.10.0/20"
name = "default"
user_tags = {
  team= "devops"
  purpose= "elk module test"
  owner= "Samir"
}
```
