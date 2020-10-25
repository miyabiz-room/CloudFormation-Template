#!/bin/sh
SYSTEM_NAME=akane
ENV_TYPE=dev

function create_stack() {
STACK_NAME=$1
aws cloudformation create-stack \
--stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
--template-body file://./${SYSTEM_NAME}/${STACK_NAME}/${STACK_NAME}.yml \
--cli-input-json file://./${SYSTEM_NAME}/${STACK_NAME}/${ENV_TYPE}-parameters.json

aws cloudformation wait stack-create-complete \
--stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}
}

create_stack network
create_stack sg
create_stack elb
create_stack waf