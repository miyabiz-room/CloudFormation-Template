#!/bin/sh

cd `dirname $0`

echo " --- \033[0;33m TEST LAMBDA \033[0;39m --- "

LAMBDA_NAME=akane-dev-lambda-waitMinutes
OUTPUT_FILE=response.json

aws lambda invoke --function-name ${LAMBDA_NAME} --log-type Tail ${OUTPUT_FILE} --query 'LogResult'  --output text |  base64 -D

cat ${OUTPUT_FILE}

exit 0