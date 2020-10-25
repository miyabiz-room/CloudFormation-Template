#!/bin/sh

cd `dirname $0`

./create_sqs_message.sh

echo " --- \033[0;33m TEST STEP_FUNCS \033[0;39m --- "

STEP_FUNCS_NAME=akane-dev-step-funcs-waitSecs
SLEEP_SEC=3

get_step_funcs_result() {
  RESPONSE=$1
  ARN_ID=`echo ${RESPONSE} | jq -r '.executionArn'`

  if [ "${ARN_ID}" == "null" ]; then
    echo ${RESPONSE}
    exit 1
  fi
  echo ${ARN_ID}
  step_funcs_status=$(aws stepfunctions describe-execution --execution-arn ${ARN_ID} | jq -r '.status')
  echo " --- \033[0;35m STEP FUNCTIONS STATUS \033[0;39m --- "
  while [ ${step_funcs_status} == "RUNNING" ] ; do
    echo "     \033[0;33m${step_funcs_status} \033[0;39m "
    sleep ${SLEEP_SEC}
    step_funcs_status=$(aws stepfunctions describe-execution --execution-arn ${ARN_ID} | jq -r '.status')
  done
  if [ $step_funcs_status == "SUCCEEDED" ]; then
    echo -e "\033[0;32m  ${step_funcs_status}\033[0;39m"
    aws stepfunctions describe-execution --execution-arn ${ARN_ID} | jq -r '.output'
  else
    echo -e "\033[0;31m  ${step_funcs_status}\033[0;39m"
  fi
}

STATE_MACHINE_ARN=`aws stepfunctions list-state-machines --query 'stateMachines' | jq -r ".[] | select(.name == \"${STEP_FUNCS_NAME}\") | .stateMachineArn"`

response=`aws stepfunctions start-execution --state-machine-arn ${STATE_MACHINE_ARN}`

get_step_funcs_result "${response}"

exit 0