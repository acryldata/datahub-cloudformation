#!/bin/bash
echo "====================================================================================="
echo "0) delete PrivateLinkStack (Acryl needs to delete private vpc endpoint if they are connected to your privatelink)"
echo "1) run 'kubectl delete ns <StackName>' to delete ALB/NLB/target groups created by ingress controller"
echo "2) trigger deletion of master Cloudformation Stack (i.e. dev-datahub),wait till EKSNodeGroupStack is deleted, then manually delete EKS cluster"
echo "3) after Cloudformation Stack is deleted, run below CleanUp-after-Stack-Deletion.sh"
echo "====================================================================================="
if [ $# -ne 3 ]; then
  echo "Usage: CleanUp-after-Stack-Deletion.sh <Environment> <StackName> <Region>"
  echo "For Example: ./CleanUp-after-Stack-Deletion.sh dev dev-datahub region"
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
aws secretsmanager delete-secret --secret-id /${Environment}/${StackName}/admin/apikey --force-delete-without-recovery --region ${Region}--no-cli-pager;


#===SSM Parameter Store===
aws ssm delete-parameters --names "/${Environment}/${StackName}/eks/oidc" "/${Environment}/${StackName}/eks/clusterSecurityGroupId" "/${Environment}/${StackName}/msk/bootstrap_brokers" "/${Environment}/${StackName}/msk/zookeeper_connect" "/${Environment}/${StackName}/kotsadm/nlbarn" "/${Environment}/${StackName}/kotsadm/nlbdns" "/${Environment}/${StackName}/admin/albarn" "/${Environment}/${StackName}/admin/albdns" --region ${Region} --no-cli-pager;

#===Log Group===
aws logs delete-log-group --log-group-name "/${Environment}/${StackName}/ProvisionHost" --region ${Region} --no-cli-pager;
aws logs delete-log-group --log-group-name "/aws/eks/${StackName}/cluster" --region ${Region} --no-cli-pager;
aws logs delete-log-group --log-group-name "/aws/rds/cluster/${StackName}/error" --region ${Region} --no-cli-pager;
break;;
        No ) exit;;
    esac
done



