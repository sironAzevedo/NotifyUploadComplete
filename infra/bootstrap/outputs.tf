output "lambda_bucket_name" {
  value = local.name_backet_lambda
}

output "buckets_to_destroy" {
  value = local.buckets_to_fluxo
}

output "buckets_existing" {
  description = "Lista dos buckets com status de existência"
  value = {
    for k, v in data.external.bucket_existing :
    k => {
      bucket_name = v.result.bucket_name
      exists      = v.result.exists == "true"
    }
  }
}