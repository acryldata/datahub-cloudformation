#!/bin/bash
set -x
if [ $# -ne 1 ]; then
  echo "Usage: fargate-login.sh <Stack_Name>"
  echo "For Example: ./fargate-login.sh datahub-ingestion"
  exit 1
else
  STACK_NAME=$1
fi
export AWS_PROFILE=default
### to login to fargate container
TASK_ARN=$(aws ecs list-tasks --cluster "${STACK_NAME}" --query "taskArns[*]" --output text)
echo "ECS Cluster: ${STACK_NAME} --- TASK_ARN: $TASK_ARN"
#TASK_ID=$(aws ecs  describe-tasks --cluster "${STACK_NAME}" --tasks ${TASK_ARN} --query "tasks[*].attachments[*].id" --output text)
#echo "ECS Cluster: ${STACK_NAME} --- TASK_ID: $TASK_ID"
TASK_ID=${TASK_ARN##*/}




echo "login to TASK_ID: ${TASK_ID}"
aws ecs execute-command  \
    --cluster ${STACK_NAME} \
    --task ${TASK_ID} \
    --container "${STACK_NAME}-container" \
    --command "/bin/bash" \
    --interactive
