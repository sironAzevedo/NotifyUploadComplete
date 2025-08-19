#!/bin/bash
BUCKET_NAME=$1

if aws s3 ls "s3://$BUCKET_NAME" 2>&1 | grep -q 'NoSuchBucket'
then
  echo "{ \"exists\": false }"
else
  echo "{ \"exists\": true }"
fi