# Terraform VPC Peering Module

Refer <https://registry.terraform.io/modules/grem11n/vpc-peering/aws/latest> which seems to be the best one

## Examples

```bash
provider "aws" {
}

module "single_account_single_region" {
  source = "../../"

  providers = {
    aws.this = aws
    aws.peer = aws
  }

  this_vpc_id = var.this_vpc_id
  peer_vpc_id = var.peer_vpc_id

  auto_accept_peering = true

  tags = {
    Name        = "tf-single-account-single-region"
    Environment = "Test"
  }
}
```
