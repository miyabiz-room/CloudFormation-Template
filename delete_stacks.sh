#!/bin/sh
SYSTEM_NAME=akane
ENV_TYPE=dev

function delete_stack() {
STACK_NAME=$1
aws cloudformation delete-stack \
--stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}

aws cloudformation wait stack-delete-complete \
--stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}
}

delete_stack repo
