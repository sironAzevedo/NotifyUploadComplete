output "lambda_bucket_name" {
  value = coalesce(
    try(aws_s3_bucket.lambda_bucket[0].id, null),
    try(data.aws_s3_bucket.lambda_bucket_existing.id, null),
    local.name_backet_lambda
  )
}
