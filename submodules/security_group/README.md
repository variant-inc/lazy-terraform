# Security Group

Module to create security group

## Resources

- Security Group
- Security Group Rules
- Tags

<!-- markdownlint-disable MD013 -->
## Input Variables

Refer <https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest?tab=inputs>

For pre-defined rules, refer <https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf#L7-L176>

## Example .tf file module reference

```bash
module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.identifier}-rds"
  description = "Security group for ${var.identifier} RDS"
  vpc_id      = module.vpc.vpc.id
  tags        = module.tags.tags

  ingress_cidr_blocks = var.inbound_cidrs
  ingress_rules       = [local.sg_ingress_rule]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

output "security_group_id" {
  value = module.security_group.security_group_id
}
```
