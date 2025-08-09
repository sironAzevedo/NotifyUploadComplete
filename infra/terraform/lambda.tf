data "archive_file" "notify_upload_complete" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda/notify_upload_complete.zip"
}

resource "aws_lambda_function" "notify_upload_complete" {
  s3_bucket = var.lambda_s3_bucket
  s3_key    = var.lambda_s3_key  
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = aws_iam_role.notify_upload_complete.arn
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size

  source_code_hash = data.archive_file.notify_upload_complete.output_base64sha256

  environment {
    variables = {
      SQS_QUEUE_URL = aws_sqs_queue.notify_upload_complete.url
    }
  }

  tags = {
    Name = "${var.lambda_function_name}-${var.environment}"
  }

  depends_on = [
    aws_iam_role_policy_attachment.notify_upload_complete,
    aws_cloudwatch_log_group.notify_upload_complete
  ]
}

resource "aws_cloudwatch_log_group" "notify_upload_complete" {
  name              = "/aws/lambda/${var.lambda_function_name}-${var.environment}"
  retention_in_days = 10
}