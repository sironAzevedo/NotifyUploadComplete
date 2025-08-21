locals {
  name_backet_lambda  = "lambda-notifyuploadcomplete-bucket-${var.environment}"
  bucket_name_tfstate = "notifyuploadcomplete-terraform-tfstates-${var.environment}"

  lambda_bucket_existing  = data.external.lambda_bucket_existing.result.exists == "true"
  tfstate_bucket_existing = data.external.tfstate_bucket_existing.result.exists == "true"

  # Centraliza as tags comuns
  common_tags = {
    Environment = var.environment
    Project     = "NotifyUploadComplete"
    Terraform   = "true"
  }
}