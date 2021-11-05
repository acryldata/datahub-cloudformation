echo "====================================================================================="
echo "0) delete PrivateLinkStack (Acryl needs to delete private vpc endpoint if they are connected to your privatelink)"
echo "1) make sure run 'kubectl delete ns <StackName>' first"
echo "2) trigger deletion of mastere Cloudformation Stack (i.e. dev-datahub),wait till EKSNodeGroupStack is deleted, then  manually delete EKS cluster"
echo "3) after Cloudformation Stack is deleted, run below CleanUp-after-Stack-Deletion.sh"
echo "====================================================================================="
if [ $# -ne 2 ]; then
  echo "Usage: CleanUp-after-Stack-Deletion.sh <Environment> <StackName>"
  echo "For Example: ./CleanUp-after-Stack-Deletion.sh dev dev-datahub"
  exit 1
else
  Environment=$1
  StackName=$2
fi

echo "Do you want to continue?"
select yn in "Yes" "No"
case $yn in
    No ) exit;;
esac

#===Secrets===
aws secretsmanager delete-secret --secret-id /${Environment}/${StackName}/admin/password --force-delete-without-recovery --region us-west-2 --no-cli-pager
aws secretsmanager delete-secret --secret-id /${Environment}/${StackName}/admin/apikey --force-delete-without-recovery --region us-west-2 --no-cli-pager


#===SSM Parameter Store===
aws ssm delete-parameters --names "/${Environment}/${StackName}/eks/oidc" "/${Environment}/${StackName}/eks/clusterSecurityGroupId" "/${Environment}/${StackName}/msk/bootstrap_brokers" "/${Environment}/${StackName}/msk/zookeeper_connect" "/${Environment}/${StackName}/kotsadm/nlbarn" "/${Environment}/${StackName}/kotsadm/nlbdns" "/${Environment}/${StackName}/admin/albarn" "/${Environment}/${StackName}/admin/albdns" --region us-west-2 --no-cli-pager

