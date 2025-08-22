variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "dev"
}

variable "bucket_lifecycle_old_versions" {
  description = "Apagar versões antigas após N dias"
  type        = number
  default     = 2
}