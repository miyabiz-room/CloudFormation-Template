import os
import json
from time import sleep

def handler(event, context):

    try:
        wait_secs = int(event['wait_secs'], 10)
    except KeyError:
        wait_secs = 10

    sleep(wait_secs)

    responses = {}
    responses['message'] = 'Wait {} seconds.'.format(wait_secs)

    return {
        'statusCode': 200,
        'body': json.dumps(responses)
    }