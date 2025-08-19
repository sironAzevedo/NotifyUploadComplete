resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = local.name_backet_lambda
  force_destroy = true

  tags = {
    Name    = local.name_backet_lambda
    Project = "NotifyUploadComplete"
  }
}

# Bloquear acesso público
resource "aws_s3_bucket_public_access_block" "lambda_bucket_block" {
  bucket                  = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Habilitar versionamento
resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}