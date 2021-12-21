FROM python:3.8-alpine

WORKDIR /app

COPY ./src /app

RUN pip install -r requirements.txt

ENV SQS_QUEUE_ARN=arn:aws:sqs:us-west-2:577660233792:listener-main

ENTRYPOINT python sqs_consumer.py

