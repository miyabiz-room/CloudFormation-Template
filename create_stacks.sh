#!/bin/sh

cd `dirname $0`

SYSTEM_NAME=akane

create_stack () {
    ENV_TYPE=$1
    STACK_NAME=$2
    aws cloudformation create-stack \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --template-body file://./${SYSTEM_NAME}/${STACK_NAME}/${STACK_NAME}.yml \
    --cli-input-json file://./${SYSTEM_NAME}/${STACK_NAME}/${ENV_TYPE}-parameters.json

    aws cloudformation wait stack-create-complete \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}
}

create_stack all s3
./akane/lambda/mkzip.sh
./akane/lambda/upload_artifact.dev.sh
create_stack dev lambda
create_stack dev apigw

exit 0