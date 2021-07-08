# EKS VPC

Module to get VPC of EKS Cluster

## Resources

- EKS Cluster
- VPC

## Input Variables

| Name         | Type   | Default Value | Example     |
| ------------ | ------ | ------------- | ----------- |
| cluster_name | string |               | variant-dev |

## Example .tf file module reference

```bash
module "eks_vpc" {
  source = "github.com/variant-inc/lazy-terraform//submodules/eks-vpc?ref=v1"

  cluster_name = "variant-dev"
}

output "vpc_cidrs" {
  value = module.eks_vpc.vpc.cidr_block_associations.*.cidr_block
}
```
