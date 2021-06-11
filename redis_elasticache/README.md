# Elasticache Redis

Module to deploy EC2 instance and required resources in a lazy fashion

## Resources

- Security Group
- Tags
- Subnets
- Elasticache Cluster
- Elasticache Parameter Group

## Input Variables

 | Name               | Type          | Default             | Example           |
 | ------------------ | ------------- | ------------------- | ----------------- |
 | profile            | string        | default             |                   |
 | domain_name        | string        |                     | eng-cache         |
 | family             | string        | redis6.x            |                   |
 | node_type          | string        | cache.m6g.large     | cache.m6g.xlarge  |
 | engine_version     | string        | 6.x                 |                   |
 | maintenance_window | string        | sun:05:00-sun:09:00 |                   |
 | vpc_id             | string        | (optional)          | vpc-26r9f023fh2f3 |
 | inbound_cidrs      | array(string) | ["0.0.0.0/0"]       |                   |
 | user_tags          | object        |                     | `see below`       |
 | octopus_tags       | object        |                     | `see below`       |

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
  type        = map(string)
}

module "cache_cluster" {
  source = "github.com/variant-inc/lazy-terraform//redis_elasticache?ref=v1"

  domain_name = "test"
  vpc_id      = "vpc-0812cf48c9ea4e042"
  user_tags = {
    team    = "devops"
    purpose = "elk module test"
    owner   = "Samir"
  }
  octopus_tags = var.octopus_tags # If run from octopus, this will be auto populated
}
```

## Get Cluster details

```bash
data "aws_elasticache_cluster" "cluster" {
  cluster_id = "my-cluster-id"
}

output "cluster_address" {
  value      = aws_elasticache_cluster.cluster.cache_nodes.0.address
}
```
