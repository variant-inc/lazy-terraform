# Terraform VPC Peering Module Between Accounts

## Resources

* Tags

## Input Variables

| Name            | Type        | Default | Example                                                                         |
|-----------------|-------------|---------|---------------------------------------------------------------------------------|
| name_tag_value  | string      |         |                                                                                 |
| user_tags       | map(string) |         | {   team    =  "devops"   purpose =  "vpc peering test"   owner   =  "naveen" } |
| octopus_tags    | map(string) |         | {   project         =  "test"   space           =  "Default" }                  |
| vpc_src_region  | string      |         | us-east-1                                                                       |
| vpc_dest_region | string      |         | us-east-2                                                                       |

For `user_tags` , refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```

## Examples

provider.tf

```bash
provider "aws" {
  alias  = "this"
  region = var.vpc_src_region
}

provider "aws" {
  alias  = "peer"
  region = var.vpc_dest_region
}
```

main.tf

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
variable "user_tags" {
  description = "User tags"
  type        = map(string)
}

variable "name_tag_value" {
  description = "Name tag value"
}

variable "vpc_src_region" {
  description = "VPC requestor region"
}

variable "vpc_dest_region" {
  description = "VPC acceptor region"
}

module "vpc_peering" {
  source = "github.com/variant-inc/lazy-terraform//vpc_peering?ref=v1"
  #For branch
  #source = "github.com/variant-inc/lazy-terraform//vpc_peering?ref=feature/CLOUD-756-vpc-peering-with-name-tag"
  name_tag_value= var.name_tag_value
  user_tags = var.user_tags
  octopus_tags = var.octopus_tags # If run from octopus, this will be auto set
}
```

.tfvars

```bash
vpc_src_region="us-east-1"
vpc_dest_region="us-east-1"
name_tag_value="peering-vpc"
user_tags = {
  team    = "devops"
  purpose = "vpc peering test"
  owner   = "naveen"
}
octopus_tags = {
  project         = "test"
  space           = "Default"
}

```

## Ouput Variables

| Name                      | Type   |
|---------------------------|--------|
| acceptor_vpc_id           | string |
| requester_vpc_id          | string |
| vpc_peering_id            | string |
| vpc_peering_accept_status | string |

## References

Refer <https://registry.terraform.io/modules/grem11n/vpc-peering/aws/latest> which seems to be the best one
