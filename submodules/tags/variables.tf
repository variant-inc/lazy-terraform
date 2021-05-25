variable "user_tags" {
  description = "Mandatory tags for all resources"
  type = object({
    octopus-project_name = string
    octopus-space_name   = string
    team                 = string
    purpose              = string
    owner                = string
  })
}

variable "name" {
  description = "Name of the resource"
  type = string
}
