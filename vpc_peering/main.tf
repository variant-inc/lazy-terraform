module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  name         = "tf-vpc-peering"
  octopus_tags = var.octopus_tags
}

data "aws_vpc" "srcVpc" {
  provider = aws.this
  filter {
    name   = "tag-value"
    values = ["${var.src_name_tag}"]
  }
  filter {
    name   = "tag-key"
    values = ["Name"]
  }
}

data "aws_vpc" "destVpc" {
  provider = aws.peer
  filter {
    name   = "tag-value"
    values = ["${var.dest_name_tag}"]
  }
  filter {
    name   = "tag-key"
    values = ["Name"]
  }
}

// Creates a peering between VPCs different accounts and different regions
module "vpc_peering" {
  source  = "grem11n/vpc-peering/aws"
  version = "4.0.1"

  providers = {
    aws.this = aws.this
    aws.peer = aws.peer
  }

  this_vpc_id = data.aws_vpc.srcVpc.id
  peer_vpc_id = data.aws_vpc.destVpc.id

  auto_accept_peering = true
  tags                = module.tags.tags
}
