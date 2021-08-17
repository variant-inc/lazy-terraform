# Get data for tags
data "aws_caller_identity" "current" {}

locals {
  user_tags = {
    for k, v in var.user_tags :
    replace(k, "-", "/") => v
  }

  common_tags = {
    "Name"                    = var.name
    "aws/account_number"      = data.aws_caller_identity.current.account_id
    "octopus/project"         = var.octopus_tags.project
    "octopus/space"           = var.octopus_tags.space
    "octopus/environment"     = lookup(var.octopus_tags, "environment", '')
    "octopus/project_group"   = lookup(var.octopus_tags, "project_group", '')
    "octopus/release_channel" = lookup(var.octopus_tags, "release_channel", '')
  }

  tags = merge(local.common_tags, local.user_tags)
}
