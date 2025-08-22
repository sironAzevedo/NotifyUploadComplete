data "external" "bucket_existing" {
  for_each = toset(local.buckets_to_fluxo)

  program = [
    "bash",
    "${path.module}/script/check_s3.sh",
    each.key
  ]
}

resource "aws_s3_bucket" "bucket" {
  for_each = {
    for name, result in data.external.bucket_existing :
    name => result if result.result.exists == "false"
  }

  bucket        = each.key
  force_destroy = true
  tags          = local.common_tags
}

# Bloquear acesso público lambda_bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket_block" {
  for_each = {
    for name, result in data.external.bucket_existing :
    name => result if result.result.exists == "false"
  }
  
  bucket                  = each.key
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}