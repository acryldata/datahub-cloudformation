# Cloudformation Demo
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

     - choose Oregon region -> Cloudformation -> Create stack

     - Template Amazon S3 URL: https://cf-templates-xxx-us-west-2.s3.us-west-2.amazonaws.com/dev/templates/datahub-deployment.yaml

     - Stack name: dev-datahub
 
     - TemplateBucketName: cf-templates-xxx-us-west-2     

     - Environment: dev

     - The AZ's to deploy to: choose 'us-west-2a, us-west-2b, us-west-2c'

     - The AWS IAM Role arn: existing IAM role arn to be granted EKS access

     - ELB cert arn: ACM cert arn to be attached to new create ALB

     - CreatePrivateLink: Choose 'true' to create private link endpoint service

     - RemoveTempResources: if you want to keep admin provision host, choose 'false'

     - Tags, can have customized tags here, no space allowed in either Key or Value

     - Stack failure options: choose 'Preserve successfully provisioned resources' (useful when working on development of cloudformation)

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
     - under Acryl AWS account, us-west-2 region, find service by service name, for example com.amazonaws.vpce.us-west-2.vpce-svc-*** (get service name from step 4.), select shared vpc, choose 3 private subnets, attach default security group

     - access https://{vpc_endpoint_dns} to use manage datahub release


## To cleanup, see CleanUp-after-Stack-Deletion.sh
