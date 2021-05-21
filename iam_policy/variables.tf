variable "profile" {
  description = "AWS Profile"
  default     = "default"
}

variable "region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "policy_description" {
  description = "AWS IAM Policy Description"
  default     = ""
}

variable "policy_name" {
  description = "AWS IAM Policy Name"
  default     = "policy-name-not-provided"
}

variable "policy_json" {
  description = "IAM Policy Definition"
  type = object({
    Version = string
    Statement = list(object({
      Sid      = string
      Effect   = string
      Action   = string
      Resource = string
    }))
  })
}
