#!/bin/bash
set -x
if [ $# -ne 7 ]; then
  echo "Usage: acryl-executor-ecs-stack.sh <Stack_Name> <DataHubBaseUrl> <DataHubAccessToken> <AwsAccessKeyId> <AwsSecretAccessKey> <AwsRegion> <AwsCommandQueueUrl>"
  echo "For Example: ./acryl-python-ingestion-stack.sh datahub-ingestion https://staging.acryl.io/gms ..."
  exit 1
else
  STACK_NAME=$1
  DATAHUB_BASE_URL=$2
  DATAHUB_ACCESS_TOKEN=$3
  AWS_ACCESS_KEY_ID=$4
  AWS_SECRET_ACCESS_KEY=$5
  AWS_REGION=$6
  AWS_COMMAND_QUEUE_URL=$7
fi
export AWS_PROFILE=default
### use private subnet
#aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://./templates/python.ecs.template.yaml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=SubnetID,ParameterValue=subnet-0127a3f6a25ae5b7e ParameterKey=VPCID,ParameterValue=vpc-03042805f5912d718 --no-cli-pager

### use public subnet
aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://./templates/python.ecs.template.yaml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=SubnetID,ParameterValue=subnet-01ed822856d08496c ParameterKey=VPCID,ParameterValue=vpc-0de7cd0350c7d7a5f ParameterKey=DataHubBaseUrl,ParameterValue=${DATAHUB_BASE_URL} ParameterKey=DataHubAccessToken,ParameterValue=${DATAHUB_ACCESS_TOKEN} ParameterKey=AwsAccessKeyId,ParameterValue=${AWS_ACCESS_KEY_ID} ParameterKey=AwsSecretAccessKey,ParameterValue=${AWS_SECRET_ACCESS_KEY} ParameterKey=AwsRegion,ParameterValue=${AWS_REGION} ParameterKey=AwsCommandQueueUrl,ParameterValue=${AWS_COMMAND_QUEUE_URL} ParameterKey=TaskCpu,ParameterValue=1024 ParameterKey=TaskMemory,ParameterValue=2048 --no-cli-pager
