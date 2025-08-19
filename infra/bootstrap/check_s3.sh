#!/bin/bash
BUCKET_NAME=$1

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "{\"exists\": \"true\"}"
else
  echo "{\"exists\": \"false\"}"
fi