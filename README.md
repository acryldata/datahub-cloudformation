# Cloudformation Demo
![AcryDatahubCFN](https://user-images.githubusercontent.com/1105928/138394072-c86ddffa-5b6d-433f-95c8-3764842445d4.png)

## step 1 to 5 runs on customer AWS account


1. upload templates/scripts/license to S3

     - upload needed files to S3 bucket 'cf-templates-blrxgroup-us-west-2', under folder 'development'
```console
cd cloudformation
export AWS_PROFILE=***
./s3upload.sh cf-templates-blrxgroup-us-west-2 development
```

      
2. create stack to deploy datahub platform in AWS

     - choose Oregon region -> Cloudformation -> Create stack

     - Template Amazon S3 URL: https://cf-templates-blrxgroup-us-west-2.s3.us-west-2.amazonaws.com/development/templates/datahub-deployment.yaml

     - Stack name: datahub

     - The AZ's to deploy to: choose 'us-west-2a, us-west-2b, us-west-2c'

     - The key pair name to use to access the instances: choose 'developer'

     - The CIDR block to allow remote access: YOURIP/32, can find your IP from https://www.whatismyip.com/

     - Stack failure options: choose 'Preserve successfully provisioned resources' (useful when working on development of cloudformation)

     - check:
          - "I acknowledge that AWS CloudFormation might create IAM resources with custom names."
          - "I acknowledge that AWS CloudFormation might require the following capability: CAPABILITY_AUTO_EXPAND"

     - click "Create stack"

     - you will see a stack 'datahub' (this is master stack), and it will invoke nested stacks in order



3. find datahub platform info
     - after Stack Info show Status 'CREATE_COMPLETE', you can find needed info from nested stack <<datahub-AdminStack-***>>'s Outputs



4. create vpc endpoint
     - wait till datahub-kotsadm network load balancer's status is Active
     - create stack
          - Stack Name: datahub-privatelink
          - Template Amazon S3 URL: https://cf-templates-blrxgroup-us-west-2.s3.us-west-2.amazonaws.com/development/templates/nested/privatelink.yaml
          

5. manually update DNS record
     - find datahub.dev.blrxgroup.com in public hosted zone 'dev.blrxgroup.com', update it to point to new ALB (for example, dualstack.k8s-datahub-***.us-west-2.elb.amazonaws.com.)

     - access https://datahub.dev.blrxgroup.com for datahub app


## step 6 runs on Acryl AWS account
6. manually create VPC endpoint
     - under Acryl AWS account, us-west-2 region, find service by service name, for example com.amazonaws.vpce.us-west-2.vpce-svc-*** (get service name from step 4.), select shared vpc, choose 3    private subnets, attach default security group

     - access https://{vpc_endpoint_dns} to for kotsadmin, default password: Passw0rd
