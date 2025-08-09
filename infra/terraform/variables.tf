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
variable "lambda_s3_bucket" {
  type        = string
  description = "Nome do bucket S3 onde o pacote da Lambda será armazenado"
}

variable "lambda_s3_key" {
  type        = string
  description = "Chave (path) no bucket S3 para o pacote da Lambda"
}

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
