#!/bin/sh

cd `dirname $0`

SYSTEM_NAME=akane

delete_stack () {
    ENV_TYPE=$1
    STACK_NAME=$2
    export AWS_DEFAULT_REGION=$3
    aws cloudformation delete-stack \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}

    aws cloudformation wait stack-delete-complete \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}
}

delete_stack dev s3 ap-northeast-1
delete_stack dev s3 ap-northeast-3

exit 0
