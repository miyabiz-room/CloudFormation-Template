import os
import json

def handler(event, context):

    try:
        name = event['pathParameters']['name']
    except TypeError:
        name = 'Miyabi'
    except KeyError:
        name = 'Miyabi'

    responses = {}
    responses['message'] = '正常に取得しました'
    responses['result'] = {}
    responses['result'][os.environ['GIRL_NAME']] = '{}! Ti Amo!'.format(name)

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers' : 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,GET'
        },
        'body': json.dumps(responses)
    }