#!/bin/sh

cd `dirname $0`

SYSTEM_NAME=akane

create_stack () {
    ENV_TYPE=$1
    STACK_NAME=$2
    export AWS_DEFAULT_REGION=$3
    aws cloudformation create-stack \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --template-body file://./${SYSTEM_NAME}/${STACK_NAME}/${STACK_NAME}.yml \
    --cli-input-json file://./${SYSTEM_NAME}/${STACK_NAME}/${ENV_TYPE}-parameters.json

    aws cloudformation wait stack-create-complete \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}
}

create_change_set () {
    ENV_TYPE=$1
    STACK_NAME=$2
    export AWS_DEFAULT_REGION=$3

    if [ ${STACK_NAME} == "s3-replication" ]; then
        STACK_FULLNAME=${SYSTEM_NAME}-${ENV_TYPE}-s3
    else
        STACK_FULLNAME=${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}
    fi

    aws cloudformation create-change-set \
    --stack-name ${STACK_FULLNAME} \
    --change-set-name ${STACK_FULLNAME}-change-set \
    --template-body file://./${SYSTEM_NAME}/${STACK_NAME}/${STACK_NAME}.yml \
    --cli-input-json file://./${SYSTEM_NAME}/${STACK_NAME}/${ENV_TYPE}-parameters.json

    aws cloudformation wait change-set-create-complete \
    --stack-name ${STACK_FULLNAME} \
    --change-set-name ${STACK_FULLNAME}-change-set

    aws cloudformation execute-change-set \
    --stack-name ${STACK_FULLNAME} \
    --change-set-name ${STACK_FULLNAME}-change-set
}

create_stack dev s3 ap-northeast-1
create_stack dev s3 ap-northeast-3
create_change_set dev s3-replication ap-northeast-1
create_change_set dev s3-replication ap-northeast-3

exit 0
