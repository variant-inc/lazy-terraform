variable "topic_name" {
    type = string
    description = "Name of topic to subscribe the SQS queue to"
}

variable "queue_name" {
    type = string
    description = "Name of SQS queue to subscribe to a the topic"
}

variable "use_raw_delivery" {
    type = bool
    default = true
    description = "Enables raw message delivery (strips SNS message envelope before pushing to SQS)"
}

variable "sns_filter" {
    type = string
    description = "Message filter to apply to the SNS to SQS subscription"
    default = null
}
