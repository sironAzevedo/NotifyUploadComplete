resource "aws_sqs_queue" "notify_upload_complete" {
  name                       = "${var.sqs_queue_name}-${var.environment}"
  delay_seconds              = 0
  max_message_size          = 262144 # 256KB
  visibility_timeout_seconds = 30
  receive_wait_time_seconds = 10
  message_retention_seconds  = var.sqs_message_retention_seconds
  tags = {
    Name = "${var.sqs_queue_name}-${var.environment}"
  }
}

output "sqs_queue_url" {
  value = aws_sqs_queue.notify_upload_complete.id
}
