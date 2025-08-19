# Tenta buscar bucket
data "aws_s3_bucket" "lambda_bucket_existing" {
  bucket = local.name_backet_lambda
}

data "aws_s3_bucket" "tfstate_bucket_existing" {
  bucket = local.bucket_name_tfstate
}

resource "aws_s3_bucket" "lambda_bucket" {
  count         = length(try(data.aws_s3_bucket.lambda_bucket_existing.id, "")) == 0 ? 1 : 0
  bucket        = local.name_backet_lambda
  force_destroy = true
  tags          = local.common_tags
}

resource "aws_s3_bucket" "tfstate" {
  count         = length(try(data.aws_s3_bucket.tfstate_bucket_existing.id, "")) == 0 ? 1 : 0
  bucket        = local.bucket_name_tfstate
  force_destroy = true
  tags          = local.common_tags
}

# Bloquear acesso público lambda_bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket_block" {
  count                   = length(try(data.aws_s3_bucket.lambda_bucket_existing.id, "")) == 0 ? 1 : 0
  bucket                  = aws_s3_bucket.lambda_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bloquear acesso público tfstate_bucket
resource "aws_s3_bucket_public_access_block" "terraform_tfstate_bucket_block" {
  count                   = length(try(data.aws_s3_bucket.tfstate_bucket_existing.id, "")) == 0 ? 1 : 0
  bucket                  = aws_s3_bucket.tfstate[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Habilitar versionamento
resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  count     = length(try(data.aws_s3_bucket.lambda_bucket_existing.id, "")) == 0 ? 1 : 0
  bucket    = aws_s3_bucket.lambda_bucket[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "tfstate_bucket_versioning" {
  count     = length(try(data.aws_s3_bucket.tfstate_bucket_existing.id, "")) == 0 ? 1 : 0
  bucket    = aws_s3_bucket.tfstate[0].id
  versioning_configuration {
    status = "Enabled"
  }
}