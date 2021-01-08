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
  type        = list
}

variable "iam_path" {
  description = "IAM Path"
  default     = ""
}