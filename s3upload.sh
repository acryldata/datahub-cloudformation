#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: s3upload.sh <TemplateBucketName> <TemplateBucketKeyPrefix>"
  exit 1
else
  S3_BUCKET=$1
  S3_KEY_PREFIX=$2

  # Check if access to the bucket
  if aws s3 ls "s3://$S3_BUCKET" 2>&1 | grep -q 'An error occurred'
  then
    echo "No access to S3 bucket: $S3_BUCKET !"
    exit 1
  fi

  aws s3 cp ./templates s3://$S3_BUCKET/$S3_KEY_PREFIX/templates --recursive
  aws s3 cp ./scripts s3://$S3_BUCKET/$S3_KEY_PREFIX/scripts --recursive
  aws s3 cp ./license s3://$S3_BUCKET/$S3_KEY_PREFIX/license --recursive
fi
