locals {
  user_tags = {
    for k, v in var.user_tags :
    replace(k, "-", "/") => v
  }

  common_tags = {
    "Name"                    = var.name
    "octopus/project"         = var.octopus_tags.project
    "octopus/space"           = var.octopus_tags.space
    "octopus/environment"     = var.octopus_tags.environment
    "octopus/project_group"   = var.octopus_tags.project_group
    "octopus/release_channel" = var.octopus_tags.release_channel
  }

  tags = merge(local.common_tags, local.user_tags)
}
