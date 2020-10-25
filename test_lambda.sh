#!/bin/sh

LAMBDA_NAME=akane-all-macro-lambda
PAYLOAD_DIR=akane/macro/test_data/

test_lambda() {
    PAYLOAD_FILE=${PAYLOAD_DIR}$1.json
    aws lambda invoke --function-name ${LAMBDA_NAME} --log-type Tail --payload fileb://${PAYLOAD_FILE} log.txt --query 'LogResult'  --output text |  base64 -D
}

test_lambda upper
