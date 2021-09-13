# Aliases are required because of cross-region
provider "aws" {
  alias  = "this"
  region = var.vpc_src_region
}

provider "aws" {
  alias  = "peer"
  region = var.vpc_dest_region
}
