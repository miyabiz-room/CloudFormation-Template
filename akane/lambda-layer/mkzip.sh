#!/bin/sh

cd `dirname $0`

ENV_TYPE=all
LAMBDA_NAME=$(cat ${ENV_TYPE}-parameters.json | jq -r '.Parameters[] | select(.ParameterKey == "LambdaLayerName").ParameterValue')

FILE=../../code-lambda-${LAMBDA_NAME}.zip

cd ./code/python

ls . |  grep -v -E ".gitignore|${LAMBDA_NAME}.py|requirements.txt" | xargs rm -rf

pip3 install -r requirements.txt -t .

rm -f ${FILE}
zip -r ${FILE} ./../*

exit 0