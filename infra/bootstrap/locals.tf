locals {
  name_backet_lambda  = "lambda-notifyuploadcomplete-bucket-${var.environment}"

  buckets_to_fluxo = [
    local.name_backet_lambda,
    "notifyuploadcomplete-terraform-tfstates-${var.environment}"
  ]

  # Centraliza as tags comuns
  common_tags = {
    Environment = var.environment
    Project     = "NotifyUploadComplete"
    Terraform   = "true"
  }
}