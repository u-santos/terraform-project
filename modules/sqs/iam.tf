data "aws_iam_policy_document" "consumer" {
  statement {
    effect    = "Allow"
    resources = [aws_sqs_queue.queue.arn]

    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage*",
      "sqs:PurgeQueue",
      "sqs:ChangeMessageVisibility*"
    ]
  }
}

data "aws_iam_policy_document" "pusher" {
  statement {
    effect    = "Allow"
    resources = [aws_sqs_queue.queue.arn]

    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:SendMessage*"
    ]
  }
}

resource "aws_iam_policy" "consumer" {
  name   = var.fifo_queue == true ? "sqs-${var.name}-${var.environment}.fifo-consumer" : "sqs-${var.name}-${var.environment}-consumer"
  policy = data.aws_iam_policy_document.consumer.json
}

resource "aws_iam_policy" "pusher" {
  name   = var.fifo_queue == true ? "sqs-${var.name}-${var.environment}.fifo-pusher" : "sqs-${var.name}-${var.environment}-pusher"
  policy = data.aws_iam_policy_document.pusher.json
}
