import os
import sys
import boto3
import logging

sqs = boto3.client('sqs',region_name=os.environ['AWS_REGION'])

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    logger.debug(event)
    queueName = os.environ['SQS_QUEUE_NAME']
    urlresponse = sqs.get_queue_url(
        QueueName=queueName
    )

    queueUrl = urlresponse['QueueUrl']
    logger.debug(queueUrl)
    sqs.delete_message(
        QueueUrl=queueUrl,
        ReceiptHandle=event[os.environ['LAMBDA_NAME_TO_GET_LOCK']]['ReceiptHandle']
    )

    response = sqs.send_message(
        QueueUrl=queueUrl,
        DelaySeconds=0,
        MessageBody=os.environ['SQS_MESSAGE_BODY'],
    )
    return