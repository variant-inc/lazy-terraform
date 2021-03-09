provider "aws" {
  region = var.region
  profile = var.aws_profile
}

provider "aws" {
  region = "us-east-1"
  profile = var.aws_profile
  alias = "replica"
}
