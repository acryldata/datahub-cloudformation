#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Usage: s3upload.sh <TemplateBucketName> <Environment> <LicenseFile>"
  echo "For Example: ./s3upload.sh cf-templates-XXX-us-west-2 dev /Users/XXX/Downloads/XXX-customer1.yaml"
  exit 1
else
  S3_BUCKET=$1
  S3_KEY_PREFIX=$2
  LICENSE=$3

  # upload license file to s3 bucket
  cp $3 ./license/license.yaml
  if [ $? -eq 0 ]; then
    aws s3 cp ./license s3://$S3_BUCKET/$S3_KEY_PREFIX/license --recursive
    rm ./license/license.yaml
  fi

  # Check if access to the bucket
  if aws s3 ls "s3://$S3_BUCKET" 2>&1 | grep -q 'An error occurred'
  then
    echo "No access to S3 bucket: $S3_BUCKET !"
    exit 1
  fi

  #aws s3 sync ./templates s3://$S3_BUCKET/$S3_KEY_PREFIX/templates
  aws s3 sync ./templates s3://$S3_BUCKET/$S3_KEY_PREFIX/templates --exclude 'nested/amazon-eks/functions/source*'
  aws s3 sync ./scripts s3://$S3_BUCKET/$S3_KEY_PREFIX/scripts
fi
