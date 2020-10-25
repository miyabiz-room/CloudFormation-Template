#!/bin/sh

cd `dirname $0`

LAMBDA_NAME=akane-dev-lambda-getEC2InfoToSlack
OUTPUT_FILE=response.json

aws lambda invoke --function-name ${LAMBDA_NAME} --log-type Tail ${OUTPUT_FILE} --query 'LogResult'  --output text |  base64 -D

cat ${OUTPUT_FILE}

exit 0