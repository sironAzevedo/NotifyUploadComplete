resource "aws_iam_role" "notify_upload_complete" {
  name = "${var.lambda_function_name}-role-${var.environment}"

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
    Name = "${var.lambda_function_name}-role-${var.environment}"
  }
}

resource "aws_iam_policy" "notify_upload_complete" {
  name        = "${var.lambda_function_name}-role-${var.environment}"
  description = "Permissions for NotifyUploadComplete Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
            "sqs:SendMessage",
            "sqs:SendMessageBatch",
            "sqs:GetQueueUrl"
            "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.notify_upload_complete.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_lambda_function.notify_upload_complete.arn
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        "Resource": "arn:aws:logs:us-east-1:547455868104:*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "s3:GetObject",
              "s3:PutObject",
              "s3:DeleteObject",
              "s3:ListBucket"
          ],
          "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "notify_upload_complete" {
  role       = aws_iam_role.notify_upload_complete.name
  policy_arn = aws_iam_policy.notify_upload_complete.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.notify_upload_complete.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
