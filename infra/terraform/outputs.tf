output "lambda_function_name" {
  value = aws_lambda_function.notify_lambda.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.notify_lambda.arn
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.notify_queue.arn
}
