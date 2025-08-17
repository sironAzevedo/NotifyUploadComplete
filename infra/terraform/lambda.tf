resource "aws_lambda_function" "notify_upload_complete" {
  function_name = local.name_prefix
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  s3_key        = local.lambda_s3_key
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = aws_iam_role.notify_upload_complete.arn
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size

  environment {
    variables = {
      SQS_QUEUE_URL = aws_sqs_queue.notify_upload_complete.url
    }
  }

  tags = {
    Name = local.name_prefix
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_cloudwatch_log_group.notify_upload_complete
  ]
}

resource "aws_cloudwatch_log_group" "notify_upload_complete" {
  name              = "/aws/lambda/${local.name_prefix}"
  retention_in_days = 14
}