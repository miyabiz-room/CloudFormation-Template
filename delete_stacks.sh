#!/bin/sh
SYSTEM_NAME=akane-cfn
ENV_TYPE=all

delete_stack () {
    STACK_NAME=$1
    aws cloudformation delete-stack \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}

    aws cloudformation wait stack-delete-complete \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}
}

delete_stack endpoint-cfn
delete_stack instance-cfn
delete_stack network
