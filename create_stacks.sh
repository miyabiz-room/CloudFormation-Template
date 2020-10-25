#!/bin/sh
SYSTEM_NAME=akane
ENV_TYPE=dev
STACK_NAME=network

aws cloudformation create-stack \
--stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
--template-body file://./${SYSTEM_NAME}/${STACK_NAME}/${STACK_NAME}.yml \
--cli-input-json file://./${SYSTEM_NAME}/${STACK_NAME}/${ENV_TYPE}-parameters.json