variable "profile" {
  description = "AWS Profile"
  default     = "devops"
}

variable "region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "aws_account_number" {
  description = "AWS Account Number"
  default     = ""
}

variable "policy_description" {
  description = "AWS IAM Policy Description"
  default     = ""
}

variable "policy_name" {
  description = "AWS IAM Policy Name"
  default     = "policy-name-not-provided"
}
