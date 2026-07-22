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
    - ExecutorPoolId: unique Executor Pool Id (previously known as Executor Id). Defaults to "remote". Do not prefix it with "default" for a remote executor. Do not change this without consulting with your Acryl rep.
    - Channel: the channel the executor pool listens on. "SQS" (default) runs the standard worker; "KAFKA" runs the kafka-worker. Do not change this without consulting with your Acryl rep.
    - To use existing datahub access token from AWS secrets manager, fillout below
        - ExistingDataHubAccessTokenSecretArn
    - To use optional existing secrets from AWS secrets manager, fillout below
        - OptionalSecrets
    - To use datahub access token directly, fillout below
        - DataHubAccessToken (it will create secret in secrets manager and use it)

    - Optional executor tuning (leave blank unless instructed by an Acryl engineer):
        - DataHubIngestionsMaxWorkers: max ingestion tasks allowed to run in parallel
        - DataHubMonitorsMaxWorkers: max monitoring tasks allowed to run in parallel
        - DataHubIngestionsSignalPollInterval: ingestion queue signal polling interval
        - OptionalEnvVars: extra environment variables set directly on the container (up to 10, comma-separated NAME=VALUE pairs)

    - ImageTag: if empty, uses the latest release; otherwise the given tag, for example: v2.0.4-cloud
    - DesiredCount: number of worker replicas (default 1)
    - TaskCpu: please reference https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for available combination
    - TaskMemory: please reference https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for available combination
    - TaskEphemeralStorageSizeInGiB: ephemeral storage (GiB) for the task; increase if you hit "No space left on device" during large ingestions
