# RDS

Module to create RDS. Currently only `postgres` is supported.

## Resources

- Security Group
- Tags
- Subnets
- Null Resource
- DB Module

## Input Variables

 | Name                         | Type          | Default             | Example           |
 | ---------------------------- | ------------- | ------------------- | ----------------- |
 | profile                      | string        | default             |                   |
 | allocated_storage            | number        | 100                 | eng-cache         |
 | family                       | string        | postgres13          |                   |
 | inbound_cidrs                | array(string) | ["0.0.0.0/0"]       |                   |
 | env                          | dev/prod      | dev                 |                   |
 | engine                       | string        | postgres            |                   |
 | engine_version               | string        | 13                  |                   |
 | identifier                   | string        |                     | eng-rds           |
 | instance_class               | string        | db.r6g.large        |                   |
 | username                     | string        | variant             |                   |
 | allow_major_version_upgrade  | bool          | false               |                   |
 | apply_immediately            | bool          | false               |                   |
 | backup_window                | string        | 16:00-17:00         |                   |
 | maintenance_window           | string        | sun:05:00-sun:09:00 |                   |
 | iops                         | number        | 1000                |                   |
 | max_allocated_storage        | number        | 1000                |                   |
 | storage_type                 | string        | gp2                 |                   |
 | multi_az                     | bool          | false               |                   |
 | vpc_id                       | string        | (optional)          | vpc-26r9f023fh2f3 |
 | performance_insights_enabled | bool          | false               |                   |
 | user_tags                    | object        |                     | `see below`       |
 | octopus_tags                 | object        |                     | `see below`       |

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

module "cache_cluster" {
  source = "github.com/variant-inc/lazy-terraform//rds?ref=v1"

  identifier = "test"
  user_tags = {
    team= "devops"
    purpose= "elk module test"
    owner= "Samir"
  }
  env = "prod"
  storage_type = "io1"
  apply_immediately = true
  octopus_tags = var.octopus_tags # If run from octopus, this will be auto populated
}
```

## Get Cluster details

```bash
data "aws_elasticache_cluster" "cluster" {
  cluster_id = "my-cluster-id"
}

output "cluster_address" {
  value = aws_elasticache_cluster.cluster.cache_nodes.0.address
}
```
