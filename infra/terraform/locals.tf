locals {
    # Define um prefixo padrão para todos os recursos
  name_prefix        = "NotifyUploadComplete-${var.environment}"
  name_backet_lambda = "lambdas-notifyuploadcomplete-bucket-${var.environment}"
  lambda_s3_key      = "NotifyUploadComplete-${var.environment}.zip"

  account_id = data.aws_caller_identity.current.account_id
  bucket_name = "${local.account_id}-notifyuploadcomplete-terraform-tfstates"

  # Cria uma lista final de ARNs, incluindo o ARN do bucket e o ARN para os objetos dentro dele.
  # Exemplo: de ["arn:aws:s3:::bucket1"] para ["arn:aws:s3:::bucket1", "arn:aws:s3:::bucket1/*"]
  s3_policy_resource_arns = flatten([
    for bucket_arn in var.lambda_allowed_s3_bucket_arns : [
      bucket_arn,
      "${bucket_arn}/*"
    ]
  ])

  # Centraliza as tags comuns
  common_tags = {
    Environment = var.environment
    Project     = "NotifyUploadComplete"
    Terraform   = "true"
  }
}