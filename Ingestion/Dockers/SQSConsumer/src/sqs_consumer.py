import os
import boto3
import logging

logging.basicConfig(level=os.environ.get("LOG_LEVEL", "INFO"))
logger = logging.getLogger(__name__)


def ensure_envvars():
    """Ensure that these environment variables are provided at runtime"""
    required_envvars = [
        "SQS_QUEUE_ARN"
    ]

    missing_envvars = []
    for required_envvar in required_envvars:
        if not os.environ.get(required_envvar, ''):
            missing_envvars.append(required_envvar)

    if missing_envvars:
        message = "Required environment variables are missing: " + \
            repr(missing_envvars)
        raise AssertionError(message)


def process_message(message_body):
    logger.info(f"Processing message: {message_body}")
    # do what you want with the message here
    pass


def main():
    logger.info("SQS Consumer starting ...")
    try:
        ensure_envvars()
    except AssertionError as e:
        logger.error(str(e))
        raise

    queue_arn = os.environ["SQS_QUEUE_ARN"]
    queue_name = queue_arn.split(':')[-1]
    aws_accountid = queue_arn.split(':')[-2]
    region_name = queue_arn.split(':')[-3]
    logger.info(f"Subscribing to queue:{queue_name},in region:{region_name},in aws account:{aws_accountid}")
    sqs = boto3.resource("sqs",region_name=region_name)
    queue = sqs.get_queue_by_name(QueueName=queue_name,QueueOwnerAWSAccountId=aws_accountid)

    while True:
        messages = queue.receive_messages(
            MaxNumberOfMessages=1,
            WaitTimeSeconds=1
        )
        for message in messages:
            try:
                process_message(message.body)
            except Exception as e:
                print(f"Exception while processing message: {repr(e)}")
                continue

            message.delete()


if __name__ == "__main__":
    main()
