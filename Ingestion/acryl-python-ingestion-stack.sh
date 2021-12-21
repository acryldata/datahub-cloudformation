#!/bin/bash
set -x
if [ $# -ne 1 ]; then
  echo "Usage: acryl-python-ingestion-stack.sh <Stack_Name>"
  echo "For Example: ./acryl-python-ingestion-stack.sh datahub-ingestion"
  exit 1
else
  STACK_NAME=$1
fi
export AWS_PROFILE=acryl-data-yzhang
### use private subnet
#aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://./templates/python.ecs.template.yaml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=SubnetID,ParameterValue=subnet-0127a3f6a25ae5b7e ParameterKey=VPCID,ParameterValue=vpc-03042805f5912d718 --no-cli-pager

### use public subnet
aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://./templates/python.ecs.template.yaml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=SubnetID,ParameterValue=subnet-01ed822856d08496c ParameterKey=VPCID,ParameterValue=vpc-0de7cd0350c7d7a5f --no-cli-pager


