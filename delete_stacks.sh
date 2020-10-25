#!/bin/sh

cd `dirname $0`

SYSTEM_NAME=akane

delete_stack () {
    ENV_TYPE=$1
    STACK_NAME=$2
    aws cloudformation delete-stack \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}

    aws cloudformation wait stack-delete-complete \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}
}

./akane/delete_app.dev.sh
delete_stack dev s3-app
delete_stack dev apigw
delete_stack dev lambda
./akane/lambda/delete_artifact.dev.sh
delete_stack all s3

exit 0