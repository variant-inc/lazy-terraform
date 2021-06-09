# VPC

Module to create SNS topics

## Resources

- SNS

## Input Variables

| Name         | Type   | Default Value | Example     |
| ------------ | ------ | ------------- | ----------- |
| name         | string |               | some-topic  |
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

## Example .tf file module reference

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}

module "sns" {
  source = "github.com/variant-inc/lazy-terraform//sns?ref=v1"

  name = "some-topic"

  user_tags = {
    team = "devops"
    purpose = "elk module test"
    owner = "Samir"
  }
  octopus_tags = var.octopus_tags
}

output "sns" {
  value = module.sns.sns
}
```
