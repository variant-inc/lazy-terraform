 module "vpc-peering" {
  source             = "clouddrove/vpc-peering/aws"
  version            = "0.13.0"

  name              = "eks-dev--to--default"
  application       = "eks"
  environment       = var.environment
  requestor_vpc_id  = var.requestor_vpc_id
  acceptor_vpc_id   = var.acceptor_vpc_id

  tags = {
    purpose = ""
    owner = ""
    env = var.environment
  }
}