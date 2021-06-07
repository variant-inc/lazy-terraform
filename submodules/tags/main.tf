# Get data for tags
data "aws_caller_identity" "current" {}

locals {
  user_tags = {
    for k, v in var.user_tags :
    replace(k, "-", "/") => v
  }

  common_tags = {
    "Name"               = var.name
    "deployed_by"        = data.aws_caller_identity.current.user_id
    "aws/account_number" = data.aws_caller_identity.current.account_id
    "octopus/project"    = var.octopus_tags.project
    "octopus/space"      = var.octopus_tags.space
  }

  tags = merge(local.common_tags, local.user_tags)
}
