variable "user_tags" {
  description = "Mandatory user tags"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "name" {
  description = "Name of role to be created"
  type        = string
}

variable "description" {
  description = "Description of role to be created"
  type        = string
  default     = null
}

variable "managed_policies" {
  description = "List of arns of managed policies to attach to new role"
  type        = list(string)
}

variable "trust_octopus_worker" {
  description = "Add iaac-octopus-worker trust relationship"
  type        = bool
  default     = false
}

variable "inline_policies" {
  description = "List of inline policy definitions"
  type = list(object({
    name = string,
    policy_json = object({
      Version = string
      Statement = list(object({
        Sid      = string
        Effect   = string
        Action   = any
        Resource = any
      }))
    })
  }))
}
