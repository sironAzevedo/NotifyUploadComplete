locals {
  name_backet_lambda  = "lambda-notifyuploadcomplete-bucket-${var.environment}"
  bucket_name_tfstate = "notifyuploadcomplete-terraform-tfstates-${var.environment}"

  # Centraliza as tags comuns
  common_tags = {
    Environment = var.environment
    Project     = "NotifyUploadComplete"
    Terraform   = "true"
  }
}