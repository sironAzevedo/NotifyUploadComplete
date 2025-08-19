resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = local.name_backet_lambda
  force_destroy = true
  tags          = local.common_tags
}

resource "aws_s3_bucket" "tfstate" {
  bucket        = local.bucket_name_tfstate
  force_destroy = true
  tags          = local.common_tags

  versioning {
    enabled = true
  }
}

# Bloquear acesso público lambda_bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket_block" {
  bucket                  = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bloquear acesso público
resource "aws_s3_bucket_public_access_block" "terraform_tfstate_bucket_block" {
  bucket                  = aws_s3_bucket.tfstate.id
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