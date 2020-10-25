#!/bin/sh

set -e

if [ $# -ne 2 ]; then
    echo " --- \033[0;31m [ERROR]: The following arguments are required \033[0;39m --- "
    echo "      \033[0;33m$0 <URL> <API_KEY>\033[0;39m"
    echo "      \033[0;33m<URL> Example: https://xxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/v1\033[0;39m"
    exit 1
fi

cd `dirname $0`

./create_sqs_message.sh

echo " --- \033[0;33m TEST APIGW \033[0;39m --- "

SLEEP_SEC=3

get_apigw_result() {
  RESPONSE=$1
  ARN_ID=`echo ${RESPONSE} | jq -r '.taskid'`

  if [ "${ARN_ID}" == "null" ]; then
    echo ${RESPONSE}
    exit 1
  fi
  echo ${ARN_ID}

  step_funcs_status=`curl -s -X POST -H 'Content-Type: application/json' \
    -H "x-api-key: ${API_KEY}" \
    -d "{\"taskid\": \"${ARN_ID}\"}" \
    "${URL}/status" | jq -r '.status'`
  echo " --- \033[0;35m STEP FUNCTIONS STATUS \033[0;39m --- "
  while [ ${step_funcs_status} == "RUNNING" ] ; do
    echo "     \033[0;33m${step_funcs_status} \033[0;39m "
    sleep ${SLEEP_SEC}
    step_funcs_status=`curl -s -X POST -H 'Content-Type: application/json' \
      -H "x-api-key: ${API_KEY}" \
      -d "{\"taskid\": \"${ARN_ID}\"}" \
      "${URL}/status" | jq -r '.status'`
  done
  if [ $step_funcs_status == "SUCCEEDED" ]; then
    echo -e "\033[0;32m  ${step_funcs_status}\033[0;39m"
    curl -s -X POST -H 'Content-Type: application/json' \
      -H "x-api-key: ${API_KEY}" \
      -d "{\"taskid\": \"${ARN_ID}\"}" \
      "${URL}/status" | jq -r '.result'
  else
    echo -e "\033[0;31m  ${step_funcs_status}\033[0;39m"
  fi
}

URL=$1
API_KEY=$2
WAIT_SECS=15

response=`curl -s -X POST -H 'Content-Type: application/json' \
-H "x-api-key: ${API_KEY}" \
-d "{\"wait_secs\": \"${WAIT_SECS}\"}" \
"${URL}/waitsecs"`
echo ${response}

get_apigw_result "${response}"

exit 0