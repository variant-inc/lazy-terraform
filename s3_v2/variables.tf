variable "bucket_name" {
  type        = string
  description = "Name of the s3 bucket. Either one of bucket_name or bucket_prefix is required. bucket_name gets highest preference"
  default     = ""
}

variable "bucket_prefix" {
  type        = string
  description = "Prefix of the s3 bucket. Either one of bucket_name or bucket_prefix is required"
  default     = ""
}

variable "lifecycle_rule" {
  type = object({
    prefix = string
    enabled = bool
    abort_incomplete_multipart_upload_days = number
    transition_storage_class = object({
      days = number
      storage_class = string
    })
    noncurrent_version_transition= object({
      days = number
      storage_class = string
    })
    noncurrent_version_expiration_days = number
  })
  description = "A configuration of object lifecycle management"
}

variable "user_tags" {
  type        = map(string)
  description = "User tags for tagging"
}

variable "octopus_tags" {
  type        = map(string)
  description = "Octopus defined tags"
}