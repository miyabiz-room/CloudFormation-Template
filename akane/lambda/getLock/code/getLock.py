import os
import sys
import boto3
import logging

sqs = boto3.client('sqs', region_name=os.environ['AWS_REGION'])
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    logger.debug(event)
    url_response = sqs.get_queue_url(
        QueueName=os.environ['SQS_QUEUE_NAME']
    )

    queue_url = url_response['QueueUrl']
    logger.debug(queue_url)
    response = sqs.receive_message(
        QueueUrl=queue_url,
        MaxNumberOfMessages=1,
        VisibilityTimeout=int(os.environ['VISIBILITY_TIMEOUT']),
        WaitTimeSeconds=0
    )

    result = {}
    if 'Messages' in response:
        message = response['Messages'][0]
        result['isSucceededLock'] = 1
        result['ReceiptHandle'] = message['ReceiptHandle']
    else:
        result['isSucceededLock'] = 0
        result['retryWaitSecs'] = int(os.environ['RETRY_WAIT_SECS'])

    logger.info(result)

    return result