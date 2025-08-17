output "lambda_function_name" {
  value = aws_lambda_function.notify_lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.notify_lambda.arn
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.notify_queue.arn
}

output "sqs_queue_url" {
  description = "URL of the SQS queue"
  value       = aws_sqs_queue.notify_upload_complete.url
}

output "sqs_queue_id" {
  value = aws_sqs_queue.notify_upload_complete.id
}

output "lambda_s3_bucket" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "lambda_s3_key" {
  value = local.lambda_s3_key
}

output "iam_role_arn" {
  description = "ARN of the IAM role for Lambda"
  value       = aws_iam_role.notify_upload_complete.arn
}
