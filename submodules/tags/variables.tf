variable "user_tags" {
  description = "Mandatory tags for all resources"
  type = object({
    team    = string
    purpose = string
    owner   = string
  })
}

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type = object({
    project         = string
    space           = string
    environment     = string
    project_group   = string
    release_channel = string
  })
}
