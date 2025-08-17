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

# Data source para obter o nome do bucket a partir do ARN fornecido
data "aws_arn" "source_bucket_arn" {
  arn = var.source_s3_bucket_arn
}

# 2. Agora, usamos o 'resource' (que é o nome do bucket) extraído do ARN 
#    para buscar os detalhes do bucket.
data "aws_s3_bucket" "source_bucket" {
  bucket = data.aws_arn.source_bucket_arn.resource
}