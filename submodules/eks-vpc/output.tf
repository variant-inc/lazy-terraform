output "vpc" {
  value = data.aws_vpc.vpc
}

output "cidr_ranges" {
  value = data.aws_vpc.vpc.cidr_block_associations.*.cidr_block
}