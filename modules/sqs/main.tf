locals {
  redrive_policy = jsonencode({
})

}

resource "aws_sqs_queue" "queue" {
  name                        = var.fifo_queue == true ? "${var.name}-${var.environment}.fifo" : "${var.name}-${var.environment}"
  tags                        = var.tags

  visibility_timeout_seconds  = var.visibility_timeout_seconds
  message_retention_seconds   = var.message_retention_seconds
  max_message_size            = var.max_message_size
  delay_seconds               = var.delay_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  redrive_policy = var.dead_letter_queue != null ? local.redrive_policy : null
  fifo_queue                  = var.fifo_queue
}
