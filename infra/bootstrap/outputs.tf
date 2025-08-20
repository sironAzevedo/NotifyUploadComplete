output "lambda_bucket_name" {
  value = coalesce(
    try(aws_s3_bucket.lambda_bucket[0].id, null),
    local.name_backet_lambda
  )
}

output "tfstate_bucket_name" {
  value = coalesce(
    try(aws_s3_bucket.tfstate[0].id, null),
    local.bucket_name_tfstate
  )
}

output "lambda_bucket_check_result" {
  value = data.external.lambda_bucket_existing.result
}

output "bucket_exists" {
  value = data.external.lambda_bucket_existing.result["exists"]
}

output "lambda_bucket_check" {
  value = data.external.lambda_bucket_existing.result.exists
}

output "lambda_bucket_created" {
  value = data.external.lambda_bucket_existing.result.exists == "true" ? false : true
}

output "tfstate_bucket_check" {
  value = data.external.tfstate_bucket_existing.result.exists
}

output "tfstate_bucket_created" {
  value = data.external.tfstate_bucket_existing.result.exists == "true" ? false : true
}