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

### LAMBDA ###
variable "lambda_runtime" {
  type    = string
  default = "python3.12"
}

variable "lambda_handler" {
  type    = string
  default = "main.lambda_handler"
}

variable "lambda_function_name" {
  type    = string
  default = "NotifyUploadComplete"
}

variable "lambda_timeout" {
  description = "Timeout for Lambda function in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memory allocation for Lambda function in MB"
  type        = number
  default     = 128
}

variable "lambda_allowed_s3_bucket_arns" {
  description = "Lista de ARNs de buckets S3 que a função Lambda terá permissão para acessar."
  type        = list(string)
  default     = []
}

### SQS ###

variable "sqs_message_retention_seconds" {
  description = "Quantidade em horas para rentenção de mensagem"
  type        = number
  default     = 1209600 # 14 dias
}

variable "sqs_queue_name" {
  type    = string
  default = "NotifyUploadComplete"
}

variable "source_s3_bucket_arn" {
  description = "ARN do bucket S3 existente que irá disparar a notificação para a Lambda."
  type        = string
}