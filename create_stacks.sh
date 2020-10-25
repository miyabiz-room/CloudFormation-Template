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

create_stack dev dynamodb
create_stack dev cognito
create_stack dev appsync
create_stack dev appsync-resolver
create_stack dev s3-app
./akane/deploy_app.dev.sh

exit 0