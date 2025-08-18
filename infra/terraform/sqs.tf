resource "aws_sqs_queue" "notify_upload_complete" {
  name                        = local.name_prefix
  delay_seconds               = 0
  max_message_size            = 262144 # 256KB
  visibility_timeout_seconds  = 30
  receive_wait_time_seconds   = 10
  message_retention_seconds   = var.sqs_message_retention_seconds
  tags                        = local.common_tags
}