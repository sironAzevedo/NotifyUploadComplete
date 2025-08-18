terraform {
  backend "s3" {
    bucket  = local.bucket_name
    region  = "us-east-1"
    encrypt = true
  }
}