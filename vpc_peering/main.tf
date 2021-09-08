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
    values = ["${title(var.name_tag_value)}", "${var.name_tag_value}"]
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
    values = ["${title(var.name_tag_value)}", "${var.name_tag_value}"]
  }
  filter {
    name   = "tag-key"
    values = ["Name"]
  }
}

// Creates a peering between VPCs different accounts and different regions
module "vpc_peering" {
  source = "github.com/grem11n/terraform-aws-vpc-peering"

  providers = {
    aws.this = aws.this
    aws.peer = aws.peer
  }

  this_vpc_id = data.aws_vpc.srcVpc.id
  peer_vpc_id = data.aws_vpc.destVpc.id

  auto_accept_peering = true
  tags                = module.tags.tags
}
