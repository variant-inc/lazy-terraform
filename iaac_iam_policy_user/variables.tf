variable "aws_account_number" {
  description = "AWS Account Number"
  default     = ""
}

variable "aws_profile" {
  description = "AWS Account Number"
  default     = "default"
}

variable "aws_default_region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "iam_policy_json" {
  description = "Contains policy"
  default     = ""
}

variable "iam_user_name" {
  description = "IAM Username"
  default     = ""
}

variable "iam_path" {
  description = "IAM Path"
  default     = ""
}

variable "iam_user_policy_name" {
  description = "Policy Name"
  default     = ""
}

variable "iam_user_policy_description" {
  description = "Policy Description"
  default     = ""
}

variable "iam_user_description" {
  description = "User Description"
  default     = ""
}