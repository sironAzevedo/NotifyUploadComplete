data "external" "lambda_bucket_existing" {
  program = ["bash", "-c", <<-EOT
    BUCKET_NAME=$1
    if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
      echo '{"exists":"true"}'
    else
      echo '{"exists":"false"}'
    fi
  EOT
  , local.name_backet_lambda]
}

data "external" "tfstate_bucket_existing" {
  program = ["bash", "-c", <<-EOT
    BUCKET_NAME=$1
    if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
      echo '{"exists":"true"}'
    else
      echo '{"exists":"false"}'
    fi
  EOT
  , local.bucket_name_tfstate]
}
resource "aws_s3_bucket" "lambda_bucket" {
  count         = data.external.lambda_bucket_existing.result.exists == "false" ? 1 : 0
  bucket        = local.name_backet_lambda
  force_destroy = true
  tags          = local.common_tags
}

resource "aws_s3_bucket" "tfstate" {
  count         = data.external.tfstate_bucket_existing.result.exists == "false" ? 1 : 0
  bucket        = local.bucket_name_tfstate
  force_destroy = true
  tags          = local.common_tags
}

# Bloquear acesso público lambda_bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket_block" {
  count                   = data.external.lambda_bucket_existing.result.exists == "false" ? 1 : 0
  bucket                  = aws_s3_bucket.lambda_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bloquear acesso público tfstate_bucket
resource "aws_s3_bucket_public_access_block" "terraform_tfstate_bucket_block" {
  count                   = data.external.tfstate_bucket_existing.result.exists == "false" ? 1 : 0
  bucket                  = aws_s3_bucket.tfstate[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Habilitar versionamento
resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  count     = data.external.lambda_bucket_existing.result.exists == "false" ? 1 : 0
  bucket    = aws_s3_bucket.lambda_bucket[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "tfstate_bucket_versioning" {
  count     = data.external.tfstate_bucket_existing.result.exists == "false" ? 1 : 0
  bucket    = aws_s3_bucket.tfstate[0].id
  versioning_configuration {
    status = "Enabled"
  }
}