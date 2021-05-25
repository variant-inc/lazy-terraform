# Get data for tags
data "aws_caller_identity" "current" {}

locals {
  user_tags = {
    for k, v in var.user_tags :
    replace(k, "-", "/") => v
  }

  common_tags = {
    "name"               = var.name
    "deployed_by"        = data.aws_caller_identity.current.user_id
    "aws/account_number" = data.aws_caller_identity.current.id
  }

  tags = merge(local.common_tags, local.user_tags)
}