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
}

variable "iam_user_name" {
  description = "IAM Username"
}

variable "iam_path" {
  description = "IAM Path"
  default     = "/"
}

variable "iam_user_policy_name" {
  description = "Policy Name"
}

variable "iam_user_policy_description" {
  description = "Policy Description"
}

variable "iam_user_description" {
  description = "User Description"
}