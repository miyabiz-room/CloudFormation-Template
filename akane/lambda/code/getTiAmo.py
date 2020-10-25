import os

def handler(event, context):
    responses = {}
    responses[os.environ['GIRL_NAME']] = 'Ti Amo!'

    return {
        'statusCode': 200,
        'body': responses
    }