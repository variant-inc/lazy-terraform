variable "profile" {
  type        = string
  default     = "default"
  description = "Credentials profile for AWS provider"
}

variable "user_tags" {
  description = "Mandatory tags for the RabbitMQ resources"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "kinesis_firehose_delivery_stream" {
  type        = string
  description = "Name of the Kinesis Firehose Delivery Stream"
}

variable "firehose_s3" {
  description = "Configurable variables for firehose s3 bucket"
  type = object({
    buffer_size                 = number
    buffer_interval             = number
    bucket_content_prefix       = string
    bucket_content_error_prefix = string
  })
  default = {
    buffer_size                 = 1
    buffer_interval             = 60
    bucket_content_prefix       = null
    bucket_content_error_prefix = null
  }

}

variable "firehose_lambda" {
  description = "Configurable variables for firehose lambda processor"
  type = object({
    filename    = string
    handler     = string
    runtime     = string
    timeout     = number
    memory_size = number
  })
}