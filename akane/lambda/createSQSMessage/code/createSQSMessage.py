import os
import boto3

sqs = boto3.client('sqs', region_name=os.environ['AWS_REGION'])

def handler(event, context):

    queue_urls = [get_all_queue_urls(os.environ['SQS_QUEUE_NAME'])]

    for queue_url in queue_urls:
        print('queue_url: ' + queue_url)
        queue_message_cnt = get_queue_message_cnt(queue_url)
        print('queue_message_cnt: ' + str(queue_message_cnt))
        if queue_message_cnt == 0:
            print(set_queue_message(queue_url))

def set_queue_message(queue_url):
    response = sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=os.environ['SQS_MESSAGE_BODY'],
    )
    return response

def get_queue_message_cnt(queue_url):
    response = sqs.get_queue_attributes(
        QueueUrl=queue_url,
        AttributeNames=[
            'ApproximateNumberOfMessages',
            'ApproximateNumberOfMessagesNotVisible',
            'ApproximateNumberOfMessagesDelayed'
        ]
    )

    if response['ResponseMetadata']['HTTPStatusCode'] == 200:
        message_cnt = int(response['Attributes']['ApproximateNumberOfMessages']) \
            + int(response['Attributes']['ApproximateNumberOfMessagesNotVisible']) \
            + int(response['Attributes']['ApproximateNumberOfMessagesDelayed'])
    else:
        message_cnt = 0

    return message_cnt

def get_all_queue_urls(queue_name_prefix, max_reults=100, next_token=None):
    """[全てのQueuesの情報を取得する]
    Args:
        queue_name_prefix ([str]): [キューの接頭辞].
        max_reults ([int]): [取得上限値]
        next_token ([list]): [次の取得マーカー]. Defaults to None.
    Returns:
        [list]: [Queuesの情報]
    """

    all_queues = []

    # 初回実行の場合
    if next_token is None:
        ret = sqs.list_queues(QueueNamePrefix=queue_name_prefix, MaxResults=max_reults)
    # 次のデータが存在する場合
    else:
        ret = sqs.list_queues(QueueNamePrefix=queue_name_prefix, MaxResults=max_reults, NextToken=next_token)

    if 'NextToken' in ret:
        all_queues = ret['QueueUrls'] + get_all_queue_urls(next_token=ret['NextToken'])
    else:
        try:
            all_queues = ret['QueueUrls']
        except KeyError:
            pass

    return all_queues