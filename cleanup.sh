#Secrets
echo "make sure run 'kubectl delete ns datahub' first', then delete Cloudformation Stack, then below"
if [ $# -ne 2 ]; then
  echo "Usage: cleanup.sh <Environment> <StackName>"
  echo "For Example: ./cleanup.sh dev dev-datahub"
  exit 1
else
  Environment=$1
  StackName=$2
fi
aws secretsmanager delete-secret --secret-id /${Environment}/${StackName}/admin/password --force-delete-without-recovery --region us-west-2 --no-cli-pager
aws secretsmanager delete-secret --secret-id /${Environment}/${StackName}/admin/apikey --force-delete-without-recovery --region us-west-2 --no-cli-pager


#SSM Parameter Store
aws ssm delete-parameters --names "/${Environment}/${StackName}/eks/oidc" "/${Environment}/${StackName}/msk/bootstrap_brokers" "/${Environment}/${StackName}/msk/zookeeper_connect" "/${Environment}/${StackName}/kotsadm/nlbarn" "/${Environment}/${StackName}/kotsadm/nlbdns" "/${Environment}/${StackName}/admin/nlbarn" "/${Environment}/${StackName}/admin/nlbarn" --region us-west-2 --no-cli-pager

