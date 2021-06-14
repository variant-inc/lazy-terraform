variable "description" {
  default = "terraform-managed secret"
  type    = string
}

variable "kms_key_id" {
  default     = null
  description = "Optional. The KMS Key ID to encrypt the secret. KMS key arn or alias can be used."
}

variable "name" {
  description = "Name of secret to store"
  type        = string
}

variable "secret_value" {
  description = "Secret value to store"
  type        = string
  sensitive   = true
}

variable "user_tags" {
  description = "User tags"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
