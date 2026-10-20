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

    - Optional container customization (advanced; leave blank unless you need to run a custom bootstrap step, such as obtaining a Kerberos ticket before ingestion starts). All of these are no-ops when empty:
        - OptionalVolumes: EFS volumes to mount into the container, up to 5, comma-separated, no spaces, each as name=fileSystemId:accessPointId:containerPath:readOnly, where readOnly is lowercase true or false, for example: scripts=fs-0123456789abcdef0:fsap-0123456789abcdef0:/mnt/scripts:true. Transit encryption is enabled, and the EFS mount targets' security group must allow NFS (TCP 2049) from the task's security group, which the stack creates and exports as the ContainerSecurityGroupId output. So the usual order is: create the stack with OptionalVolumes empty, create the EFS file system, access point and NFS rule using that output, then update the stack to set OptionalVolumes (and CustomCommand / CustomHealthCheckCommand if they live on the volume).
        - CustomCommand: replaces the container command. The string is split on single spaces with no quoting, for example: /bin/bash /mnt/scripts/start.sh; put anything that needs quoted arguments in a script. The command runs instead of the image's /start_datahub_executor.sh, so it must start the executor itself (for example by running that script once its own setup is done). A start script kept on a volume is not updated when the image is, so check it against the image's script whenever ImageTag changes.
        - CustomHealthCheckCommand: adds a container health check that runs this shell command via CMD-SHELL. When it is empty the task has no health check: ECS ignores any HEALTHCHECK built into the image. CustomHealthCheckInterval (5-300 seconds), CustomHealthCheckTimeout (2-60), CustomHealthCheckRetries (1-10) and CustomHealthCheckStartPeriod (0-300) default to 30, 10, 5 and 120, and apply only when it is set. ECS replaces a task whose health check keeps failing.
    - This template uses the AWS::LanguageExtensions transform, so creating or updating the stack needs both CAPABILITY_NAMED_IAM and CAPABILITY_AUTO_EXPAND.
