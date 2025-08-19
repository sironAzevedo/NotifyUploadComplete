output "lambda_bucket_name" {
  value = coalesce(
    try(aws_s3_bucket.lambda_bucket[0].id, null),
    local.name_backet_lambda
  )
}

output "lambda_bucket_check" {
  value = data.external.lambda_bucket_existing.result.exists
}

output "tfstate_bucket_check" {
  value = data.external.tfstate_bucket_existing.result.exists
}