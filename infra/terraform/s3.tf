# Concede permissão para o serviço S3 invocar a função Lambda
resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3ToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notify_upload_complete.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.source_s3_bucket_arn
}

# Configura a notificação de evento no bucket S3 de origem
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.notify_upload_complete.arn
    events              = ["s3:ObjectCreated:*"]
    # Você pode adicionar filtros se precisar, por exemplo:
    # filter_prefix = "uploads/"
    # filter_suffix = ".jpg"
  }

  depends_on = [aws_lambda_permission.allow_s3_to_invoke_lambda]
}

# Apagar versões antigas de arquivos após N dias
resource "aws_s3_bucket_lifecycle_configuration" "lambda_bucket_lifecycle" {
  bucket = data.aws_s3_bucket.source_bucket.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.bucket_lifecycle_old_versions #2
    }
  }
}

# Data source para obter o nome do bucket a partir do ARN fornecido
data "aws_arn" "source_bucket_arn" {
  arn = var.source_s3_bucket_arn
}

# 2. Agora, usamos o 'resource' (que é o nome do bucket) extraído do ARN 
#    para buscar os detalhes do bucket.
data "aws_s3_bucket" "source_bucket" {
  bucket = data.aws_arn.source_bucket_arn.resource
}

# ==============================================================================
# Bucket: caderneta-service-image-${var.environment}
# Armazenamento de imagens e avatares para o caderneta-service
# ==============================================================================

resource "aws_s3_bucket" "caderneta_service_image" {
  bucket = "caderneta-service-image-${var.environment}"

  tags = {
    Name        = "caderneta-service-image-${var.environment}"
    Environment = var.environment
    Project     = "caderneta"
    Terraform   = "true"
  }
}

# 1. Desbloqueia acesso público para permitir que o bucket e objetos sejam lidos publicamente
resource "aws_s3_bucket_public_access_block" "caderneta_service_image_pab" {
  bucket = aws_s3_bucket.caderneta_service_image.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 2. Configuração de CORS para permitir requisições das aplicações web frontend
resource "aws_s3_bucket_cors_configuration" "caderneta_service_image_cors" {
  bucket = aws_s3_bucket.caderneta_service_image.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "HEAD"]
    allowed_origins = [
      "https://finance-zen-76.vercel.app",
      "https://vidadefinancas.vercel.app",
      "http://localhost:8082",
      "http://127.0.0.1:5500"
    ]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# 3. Política de Bucket: Leitura pública para todos os objetos do bucket (AllowPublicRead)
resource "aws_s3_bucket_policy" "caderneta_service_image_policy" {
  bucket = aws_s3_bucket.caderneta_service_image.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.caderneta_service_image.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.caderneta_service_image_pab]
}
