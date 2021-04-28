provider "aws" {
  region = var.region
  profile = var.profile
}

provider "aws" {
  region = "us-east-1"
  profile = var.profile
  alias = "replica"
}
