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

delete_stack dev apigw
delete_stack dev lambda
./akane/lambda/delete_artifact.dev.sh
delete_stack dev acm
delete_stack all s3

exit 0