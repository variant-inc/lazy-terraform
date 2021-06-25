# Lazy EC-2 Module

Module to deploy EC2 instance and required resources in a lazy fashion

## Resources

- Security Group
- Security Group Rules
- Random Password (If nonotne provided)
- ES Service Domain
- Log Groups for ES Cluster
- Log Resource Policy for Log Groups

## Input Variables

 | Name                | Type         | Default                 | Example        |
 | ------------------- | ------------ | ----------------------- | -------------- |
 | domain_name         | string       |                         | test           |
 | es_version          | string       | 7.10                    |                |
 | vpc_id              | string       | (vpc_id of default-vpc) | vpc-1234567890 |
 | inbound_cidrs       | list(string) | \["0.0.0.0/0]           |                |
 | ebs_volume_size     | number       | 100                     |                |
 | cluster_config      | object({})   |                         | `see below`    |
 | master_user_options | object({})   |                         | `see below`    |
 | user_tags           | object       |                         | `see below`    |
 | octopus_tags        | object       |                         | `see below`    |

[cluster_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain#kibana_endpoint)

  ```bash
  dedicated_master_enabled = false
  instance_count= 4
  ```

or

  ```bash
  dedicated_master_enabled = true
  dedicated_master_count = 2
  instance_count= 4
  ```

[master_user_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain#master_user_options)

  ```bash
  master_user_name= "devops-test-user"
  master_user_password= "jbb12377(!#%TORkf2ef"
  ```

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
module "module-test" {
  source       = "github.com/variant-inc/lazy-terraform//elastic_search?ref=v1"

  domain_name  = "module-test"

  cluster_config = {
    dedicated_master_enabled = false
    instance_count           = 1
  }
  master_user_options = {
    master_user_name = "devops-test-user"
  }

  user_tags = {
    team    = "devops"
    purpose = "elk module test"
    owner   = "Samir"
  }
  octopus_tags      = var.octopus_tags # If run from octopus, this will be auto populated
}
```
