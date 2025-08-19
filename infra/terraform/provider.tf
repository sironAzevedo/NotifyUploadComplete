data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
      Terraform   = "true"
      Project     = "NotifyUploadComplete"
    }
  }
}