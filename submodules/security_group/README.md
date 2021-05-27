# Security Group

Module to create security group

## Resources

- Security Group
- Security Group Rules
- Tags

<!-- markdownlint-disable MD013 -->
## Input Variables

| Name          | Type          | Default Value | Example                                                                                                                                                              |
| ------------- | ------------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| vpc_id        | string        |               | vpc-123456789                                                                                                                                                        |
| inbound_cidrs | array[string] | ["0.0.0.0/0]  |                                                                                                                                                                      |
| port          | string        | "443"         |                                                                                                                                                                      |
| protocol      | string        | "tcp"         |                                                                                                                                                                      |
| tags          | object        |               | {<br /> octopus-project_name= "actions-test"<br /> octopus-space_name = "Default"<br /> team= "devops"<br /> purpose= "elk module test"<br /> owner= "Samir"<br /> } |
| name          | string        |               | "Test"                                                                                                                                                               |
<!-- markdownlint-enable MD013 -->

## Example .tf file module reference

```bash
  module "security_group" {
    source = "github.com/variant-inc/lazy-terraform//submodules/security_group?ref=v1"

    tags = {
      "octopus/project_name" = "actions-test"
      "octopus/space_name" = "Default"
      "team" = "devops"
      "purpose" = "elk module test"
      "owner" = "Samir"
    }
    name = "Test"
    vpc_id = "vpc-123456789"
  }
```

## Get Security Group

```bash
module "security_group" {
  source = "github.com/variant-inc/lazy-terraform//submodules/security_group?ref=v1"
  # source = "../submodules/security_group" # For testing

  tags          = var.tags
  port          = "6379"
  protocol      = "tcp"
  inbound_cidrs = var.inbound_cidrs
  name          = "${var.domain_name}-ec"
  vpc_id        = var.vpc_id
}

output "security_group_id" {
  value = module.security_group.security_group.id
}
```
