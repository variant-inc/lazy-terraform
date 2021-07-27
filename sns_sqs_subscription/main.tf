data "aws_sns_topic" "topic" {
  name = var.topic_name
}

data "aws_sqs_queue" "queue" {
  name = var.queue_name
}

data "aws_iam_policy_document" "subscription_policy" {
  policy_id = "${data.aws_sqs_queue.queue.name}-subscription"
  version   = "2012-10-17"

  statement {
    effect    = "Allow"
    resources = [data.aws_sqs_queue.queue.arn]
    actions   = ["sqs:SendMessage"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "ArnEquals"
      values   = [data.aws_sns_topic.topic.arn]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_sqs_queue_policy" "subscription_policy" {
  policy    = data.aws_iam_policy_document.subscription_policy.json
  queue_url = data.aws_sqs_queue.queue.id
}

resource "aws_sns_topic_subscription" "subscription" {
  endpoint             = data.aws_sqs_queue.queue.arn
  protocol             = "sqs"
  topic_arn            = data.aws_sns_topic.topic.arn
  raw_message_delivery = var.use_raw_delivery
  depends_on           = [aws_sqs_queue_policy.subscription_policy]
  filter_policy        = var.sns_filter
}
