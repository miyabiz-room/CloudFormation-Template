#!/bin/sh

cd `dirname $0`

SYSTEM_NAME=akane
ENV_TYPE=dev

create_stack () {
    STACK_TYPE=lambda

    STACK_SUFFIX=$1

    STACK_NAME=${SYSTEM_NAME}-${ENV_TYPE}-${STACK_SUFFIX}

    echo "create stack: ${STACK_NAME}"

    ./${SYSTEM_NAME}/${STACK_TYPE}/${STACK_SUFFIX}/mkzip.sh

    ./${SYSTEM_NAME}/${STACK_TYPE}/${STACK_SUFFIX}/upload_artifact.${ENV_TYPE}.sh

    aws cloudformation create-stack \
    --stack-name ${STACK_NAME} \
    --template-body file://./${SYSTEM_NAME}/${STACK_TYPE}/${STACK_SUFFIX}/${STACK_SUFFIX}.yml \
    --cli-input-json file://./${SYSTEM_NAME}/${STACK_TYPE}/${STACK_SUFFIX}/${ENV_TYPE}-parameters.json

    aws cloudformation wait stack-create-complete \
    --stack-name ${STACK_NAME}
}

create_stack waitSecs
create_stack getLock
create_stack setLock
create_stack createSQSMessage

exit 0