#!/bin/bash
echo "====================================================================================="
echo "0) delete PrivateLinkStack (Acryl needs to delete private vpc endpoint if they are connected to your privatelink)"
echo "1) run 'kubectl delete ns <StackName>' to delete ALB/NLB/target groups created by ingress controller"
echo "2) trigger deletion of master Cloudformation Stack (i.e. dev-datahub),wait till EKSNodeGroupStack is deleted, then manually delete EKS cluster"
echo "3) after Cloudformation Stack is deleted, run below CleanUp-after-Stack-Deletion.sh"
echo "====================================================================================="
if [ $# -ne 3 ]; then
  echo "Usage: CleanUp-after-Stack-Deletion.sh <Environment> <StackName> <Region>"
  echo "For Example: ./CleanUp-after-Stack-Deletion.sh dev dev-datahub us-west-2"
  exit 1
else
  Environment=$1
  StackName=$2
  Region=$3
fi

echo "Did you complete above step 0 to 3?"
select yn in "Yes" "No"; do
    case $yn in
        Yes )  
set -x
#===Secrets===
#aws secretsmanager delete-secret --secret-id /${Environment}/${StackName}/admin/apikey --force-delete-without-recovery --region ${Region} --no-cli-pager;


#===SSM Parameter Store===
#aws ssm delete-parameters --names "/${Environment}/${StackName}/eks/oidc" --region ${Region} --no-cli-pager;
#aws ssm delete-parameters --names "/${Environment}/${StackName}/eks/clusterSecurityGroupId" --region ${Region} --no-cli-pager;
aws ssm delete-parameters --names "/${Environment}/${StackName}/msk/bootstrap_brokers" --region ${Region} --no-cli-pager;
aws ssm delete-parameters --names "/${Environment}/${StackName}/msk/zookeeper_connect" --region ${Region} --no-cli-pager;
aws ssm delete-parameters --names "/${Environment}/${StackName}/kotsadm/nlbarn" --region ${Region} --no-cli-pager;
aws ssm delete-parameters --names "/${Environment}/${StackName}/kotsadm/nlbdns" --region ${Region} --no-cli-pager;
aws ssm delete-parameters --names "/${Environment}/${StackName}/admin/albarn" --region ${Region} --no-cli-pager;
aws ssm delete-parameters --names "/${Environment}/${StackName}/admin/albdns" --region ${Region} --no-cli-pager;

#===Log Group===
aws logs delete-log-group --log-group-name "/aws/eks/${StackName}/cluster" --region ${Region} --no-cli-pager;
aws logs delete-log-group --log-group-name "/aws/rds/cluster/${StackName}/error" --region ${Region} --no-cli-pager;
break;;
        No ) exit;;
    esac
done



