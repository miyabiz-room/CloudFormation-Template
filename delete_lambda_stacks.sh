#!/bin/sh

cd `dirname $0`

SYSTEM_NAME=akane
ENV_TYPE=dev

delete_stack () {
    STACK_TYPE=lambda

    STACK_SUFFIX=$1

    STACK_NAME=${SYSTEM_NAME}-${ENV_TYPE}-${STACK_SUFFIX}

    echo "delete stack: ${STACK_NAME}"

    ./${SYSTEM_NAME}/${STACK_TYPE}/${STACK_SUFFIX}/delete_artifact.${ENV_TYPE}.sh

    aws cloudformation delete-stack \
    --stack-name ${STACK_NAME}

    aws cloudformation wait stack-delete-complete \
    --stack-name ${STACK_NAME}
}

delete_stack createSQSMessage
delete_stack getLock
delete_stack setLock
delete_stack waitSecs

exit 0