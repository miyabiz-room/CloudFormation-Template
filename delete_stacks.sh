#!/bin/sh
SYSTEM_NAME=akane
ENV_TYPE=dev
STACK_NAME=network

aws cloudformation delete-stack \
--stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME}