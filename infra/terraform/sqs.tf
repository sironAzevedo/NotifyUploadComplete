resource "aws_sqs_queue" "notify_upload_complete" {
  name                       = local.queue_name_sqs
  delay_seconds              = 0
  max_message_size           = 262144 # 256KB
  visibility_timeout_seconds = 60
  receive_wait_time_seconds  = 10
  message_retention_seconds  = var.sqs_message_retention_seconds
  tags                       = local.common_tags
}

resource "aws_sqs_queue" "update_url_documento_expirado" {
  name                       = local.queue_name_update_url_documento_expirado
  delay_seconds              = 0
  max_message_size           = 262144 # 256KB
  visibility_timeout_seconds = 180
  receive_wait_time_seconds  = 10
  message_retention_seconds  = var.sqs_message_retention_seconds
  tags                       = local.common_tags
}

locals {
  fatura_source_queues = {
    notify_upload_complete        = aws_sqs_queue.notify_upload_complete
    update_url_documento_expirado = aws_sqs_queue.update_url_documento_expirado
  }
}

resource "aws_sqs_queue" "fatura_dead_letter" {
  for_each = local.fatura_source_queues

  name                      = "${each.value.name}-dlq"
  message_retention_seconds = 1209600 # 14 dias
  tags                      = local.common_tags
}

resource "aws_sqs_queue_redrive_allow_policy" "fatura_dead_letter" {
  for_each = local.fatura_source_queues

  queue_url = aws_sqs_queue.fatura_dead_letter[each.key].url
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns   = [each.value.arn]
  })
}

resource "aws_sqs_queue_redrive_policy" "fatura" {
  for_each = local.fatura_source_queues

  queue_url = each.value.url
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.fatura_dead_letter[each.key].arn
    maxReceiveCount     = 3
  })

  depends_on = [aws_sqs_queue_redrive_allow_policy.fatura_dead_letter]
}
