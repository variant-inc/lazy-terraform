# Terraform VPC Peering Module Between Accounts

## Resources

* Tags

## Input Variables

| Name            | Type        | Default | Example                                                                                                                                       |
|-----------------|-------------|---------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| src_name_tag    | string      |         | source_vpc                                                                                                                                    |
| dest_name_tag   | string      |         | destination_vpc                                                                                                                               |
| user_tags       | map(string) |         | {'team': 'devops', 'purpose': 'vpc peering test', 'owner': 'naveen'}                                                                          |
| octopus_tags    | map(string) |         | {'project': 'test', 'space': 'Default', 'environment': 'development', 'project_group': 'Default Project Group', 'release_channel': 'release'} |

For `user_tags` , refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```

## Examples

versions.tf

```bash
terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.30"
    }
  }
}
```

provider.tf

```bash
#Provider of the Requester VPC
provider "aws" {
  alias   = "this"
  profile = "dpl"
  region  = "us-east-1"
}

# Aliases are required because of cross-region
#Provider of the Accepter VPC
provider "aws" {
  alias   = "peer"
  profile = "dpl"
  region  = "us-east-2"
}
```

main.tf

```bash
variable "src_name_tag" {
  description = "Source Name tag value"
  type        = string
}
variable "dest_name_tag" {
  description = "Destination Name tag value"
  type        = string
}
variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
variable "user_tags" {
  description = "User tags"
  type        = map(string)
}


module "vpc_peering" {
  #source = "git::https://github.com/variant-inc/lazy-terraform.git//vpc_peering?ref=v1"
  #For branch
  source = "git::https://github.com/variant-inc/lazy-terraform.git//vpc_peering?ref=feature/CLOUD-756-vpc-peering-with-name-tag"
  providers = {
    aws.this = aws.this
    aws.peer = aws.peer
  }
  src_name_tag = var.src_name_tag
  dest_name_tag = var.src_name_tag
  user_tags      = var.user_tags
  octopus_tags   = var.octopus_tags # If run from octopus, this will be auto set
}
```

.tfvars.json

```json
{
   "src_name_tag":"source_vpc",
   "dest_name_tag":"destination_vpc",
   "user_tags":{
      "team":"devops",
      "purpose":"vpc peering test",
      "owner":"naveen"
   },
   "octopus_tags":{
      "project":"test",
      "space":"Default",
      "environment": "development",
      "project_group": "Default Project Group",
      "release_channel": "release"
   }
}
```

## Output Variables

| Name                      | Type   |
|---------------------------|--------|
| acceptor_vpc_id           | string |
| requester_vpc_id          | string |
| vpc_peering_id            | string |
| vpc_peering_accept_status | string |

## References

Refer <https://registry.terraform.io/modules/grem11n/vpc-peering/aws/latest> which seems to be the best one
