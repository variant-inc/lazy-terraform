data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_vpc" "vpc" {
  id = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
}
