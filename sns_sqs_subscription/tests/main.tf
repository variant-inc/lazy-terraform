terraform {
    backend "local" {}
    required_version = ">= 0.15.0",
}


provider "aws" {}
provider "random" {}

resource "aws_sns_topic" "test_topic" {
    name = "subscription-test-topic"
}

resource "aws_sqs_queue" "test_queue" {
    name = "subscription-test-queue"
}

module "test_subscription" {
    source = ".."
    queue_name = aws_sqs_queue.test_queue.name
    topic_name = aws_sns_topic.test_topic.name
}
