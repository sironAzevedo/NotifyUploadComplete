resource "aws_iam_role" "notify_upload_complete" {
  name = "${local.name_prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${local.name_prefix}-role"
  }
}

# Policy para acesso ao SQS
resource "aws_iam_policy" "notify_upload_complete_sqs" {
  name        = "${local.name_prefix}-role-sqs"
  description = "Permissions for NotifyUploadComplete Lambda function to interact with SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:SendMessageBatch",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.notify_upload_complete.arn
      }
    ]
  })
}

# Policy para acesso ao S3
resource "aws_iam_policy" "notify_upload_complete_s3" {
  name        = "${local.name_prefix}-role-s3"
  description = "Permissions for NotifyUploadComplete Lambda function to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = local.s3_policy_resource_arns
      }
    ]
  })
}

# Attach das policies na role
resource "aws_iam_role_policy_attachment" "notify_upload_complete_sqs" {
  role       = aws_iam_role.notify_upload_complete.name
  policy_arn = aws_iam_policy.notify_upload_complete_sqs.arn
}

resource "aws_iam_role_policy_attachment" "notify_upload_complete_s3" {
  role       = aws_iam_role.notify_upload_complete.name
  policy_arn = aws_iam_policy.notify_upload_complete_s3.arn
}

# Attach da policy básica da Lambda
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.notify_upload_complete.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
