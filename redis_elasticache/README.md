# Lazy EC-2 Module

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
 | region             | string        | us-east-1           |                   |
 | domain_name        | string        |                     | eng-cache         |
 | family             | string        | redis6.x            |                   |
 | node_type          | string        | cache.m6g.large     | cache.m6g.xlarge  |
 | engine_version     | string        | 6.x                 |                   |
 | maintenance_window | string        | sun:05:00-sun:09:00 |                   |
 | vpc_id             | string        |                     | vpc-26r9f023fh2f3 |
 | inbound_cidrs      | array(string) | ["0.0.0.0/0"]       |                   |
 | user_tags          | object        |                     | `see below`       |

## Example .tf file module reference

```bash
module "cache_cluster" {
  source = "github.com/variant-inc/lazy-terraform//redis_elasticache"
  region="us-east-1"
  profile ="0601924719241_AWSAdministratorAccess"
  domain_name = "test"
  vpc_id = "vpc-0812cf48c9ea4e042"
  user_tags = {
    octopus-project_name= "actions-test"
    octopus-space_name = "Default"
    team= "devops"
    purpose= "elk module test"
    owner= "Samir"
  }
}
```
