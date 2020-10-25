#!/bin/sh

cd `dirname $0`

ENV_TYPE=dev
LAMBDA_NAME=$(cat ${ENV_TYPE}-parameters.json | jq -r '.Parameters[] | select(.ParameterKey == "LambdaName").ParameterValue')

FILE=../code-lambda-${LAMBDA_NAME}.zip

cd ./code

ls . |  grep -v -E ".gitignore|${LAMBDA_NAME}.py" | xargs rm -rf

rm -f ${FILE}
zip -r ${FILE} ./*

exit 0