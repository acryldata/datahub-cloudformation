# Cloudformation Demo
![Acryl - Ingestion](https://user-images.githubusercontent.com/1105928/151049717-f70eaa9f-f296-4b13-88d0-936c18e5665a.png)
## step 1 to 4 runs on customer AWS account
1. create stack to deploy ingestion app in AWS
     - choose region -> Cloudformation -> Create stack

     - Specify template, Upload a template file, choose `datahub-executor.ecs.template.yaml``


2. Input Parameters
    - Stack name, for example: datahub-ingestion
    - Choose SubnetID (The subnet needs to reach internet)
    - Choose VPCID

    - To use AWS Key Id and Secrets, fillout below, if empty, will use task execution IAM role by default
        - AwsAccessKeyId
        - AwsSecretAccessKey
        - AwsRegion

    - DataHubBaseUrl: DataHub Base Url, for example: https://xxx.acryl.io/gms
    - AwsCommandQueueUrl: Command SQS Queue Url, for example: https://sqs.REGION.amazonaws.com/111111111111/xxx
    - AwsCommandQueueArn: Command SQS Queue ARN, for example: arn:aws:sqs:REGION:11111111111:xxx
    - ExecutorId: unique executor id
    - To use existing datahub access token from AWS secrets manager, fillout below
        - ExistingDataHubAccessTokenSecretArn
    - To use optional existing secrets from AWS secrets manager, fillout below
        - OptionalSecrets
    - To use datahub access token directly, fillout below
        - DataHubAccessToken (it will create secret in secrets manager and use it)


    - ImageTag: if empty, will use latest, otherwise use given tag, for example: v0.3.1.12-acryl
    - TaskCpu: please reference https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for available combination
    - TaskMemory: please reference https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for available combination
