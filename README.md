# Cloudformation Demo

This main README is for on-prem setup of DataHub for on-prem customers. For remote executor setup please see `remote-executor` folder.

![AcryDatahubCFN](https://user-images.githubusercontent.com/1105928/138394072-c86ddffa-5b6d-433f-95c8-3764842445d4.png)

## step 1 to 4 runs on customer AWS account


1. upload templates/scripts/license to S3
     - get license file from Acryl, for example: <<xxx-customer1.yaml>>

     - clone this repo

     - set AWS access, then upload needed files to your S3 bucket (for example,cf-templates-xxx-us-west-2), under folder 'dev'
```console
cd cloudformation
export AWS_PROFILE=***
./s3upload.sh cf-templates-xxx-us-west-2 dev xxx-customer1.yaml
```

      
2. create stack to deploy datahub platform in AWS

     - choose region -> Cloudformation -> Create stack

     - choose template based on your use case
         - Template Amazon S3 URL: https://cf-templates-xxx-us-west-2.s3.us-west-2.amazonaws.com/dev/templates/datahub-deployment-v2.yaml (will create new VPC with 3 Subnets first, then deploy datahub to the new VPC)
         - Template Amazon S3 URL: https://cf-templates-xxx-us-west-2.s3.us-west-2.amazonaws.com/dev/templates/datahub-deployment-v2-existing-vpc-3-subnets.yaml (will use existing VPC with 3 Subnets to deploy datahub)
         - Template Amazon S3 URL: https://cf-templates-xxx-us-west-2.s3.us-west-2.amazonaws.com/dev/templates/datahub-deployment-v2-existing-vpc-2-subnets.yaml (will use existing VPC with 2 Subnets deploy datahub)

             - StackName: dev-datahub
             - TemplateBucketName: cf-templates-xxx-us-west-2
             - Environment: dev
             - VPCID: vpc-0xxxxxxxxxxxxxxxx
             - The AZ's to deploy to: choose 3 or 2 AZs per your use case
             - The Existing Private Subnet 1 ID: subnet-1xxxxxxxxxxxxxxxx
             - The Existing Private Subnet 2 ID: subnet-2xxxxxxxxxxxxxxxx
             - The Existing Private Subnet 3 ID: subnet-3xxxxxxxxxxxxxxxx, or leave empty for 2-subnet setup

             - Enable Creation of ElasticSearch Service Role: set to true if ServiceLinked Role for ES doesn't exists

             - The AWS IAM Role arn that will be allowed to manage EKS, for example: aws:iam::AccountID:role/admin-role
             - DataHub Domain Name: datahub.a.b.c
             - ELB cert arn: arn: arn:aws:acm:REGION:AccountID:certificate/xx-xx-xx-xx-xx (ssl cert for datahub.a.b.c)
             - The Elastic Load Balancer Inbound CIDRs: comma seperated CIDR list that can access DataHub ALB

             - Kots Admin Domain Name: kotsadm.e.f.g
             - Kots ELB cert arn: arn:aws:acm:REGION:AccountID:certificate/xx-xx-xx-xx-xx (ssl cert for kotsadm.e.f.g)
             - Applicaiton: Kots application name
             - ApplicationReleaseChannel: choose Kots Application Release Channel
            

             - CreatePrivateLink: Choose 'true' to create private link endpoint service
             - RemoveTempResources: if you want to keep admin provision host, choose 'false'
     

     - Tags, can have customized tags here, no space allowed in either Key or Value

     - Stack failure options: choose 'rollback on failure'
         - for troubleshooting, choose 'Preserve successfully provisioned resources' (useful when working on development of cloudformation)

     - check:
          - "I acknowledge that AWS CloudFormation might create IAM resources with custom names."
          - "I acknowledge that AWS CloudFormation might require the following capability: CAPABILITY_AUTO_EXPAND"

     - click "Create stack"

     - you will see a stack 'dev-datahub' (this is master stack), and it will invoke nested stacks in order



3. find datahub platform info
     - after Stack Info show Status 'CREATE_COMPLETE', you can find needed info from nested stack <<dev-datahub-AdminStack-***>>'s Outputs


4. manually create DNS record
     - create datahub.xxx.xxx.com to point to the datahub-frontend ALB

     - create new routes to reach this new VPC

     - access https://datahub.xxx.xxx.com to use datahub


## step 5 runs on Acryl AWS account
5. manually create VPC endpoint
     - under Acryl AWS account, go to same region as customer, find service by service name, for example com.amazonaws.vpce.us-west-2.vpce-svc-*** (get service name from step 4.), select shared vpc, choose 3 private subnets, attach default security group

     - access https://{vpc_endpoint_dns} to use manage datahub release


