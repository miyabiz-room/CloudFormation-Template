#!/bin/sh

cd `dirname $0`

echo " --- \033[0;33m CREATE SQS MESSAGE \033[0;39m --- "

SQS_QUEUE_NAME=akane-dev-sqs-lock

create_sqs_message() {
  SQS_QUEUE_NAME=$1

  SQS_QUEUE_URL=$( \
    aws sqs get-queue-url \
      --queue-name ${SQS_QUEUE_NAME} \
      --output text \
  )
  MESSAGE_CNT=$( \
    aws sqs get-queue-attributes \
      --queue-url ${SQS_QUEUE_URL} \
      --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible ApproximateNumberOfMessagesDelayed \
      --query 'Attributes.[ApproximateNumberOfMessages,ApproximateNumberOfMessagesNotVisible,ApproximateNumberOfMessagesDelayed]' \
      | jq '.[] | tonumber' | jq --slurp 'add'
  )
  echo "MESSAGE_CNT: ${SQS_QUEUE_NAME}: ${MESSAGE_CNT}"
  if [ ${MESSAGE_CNT} == "0" ]; then
    echo "CREATE MESSAGE: ${SQS_QUEUE_NAME}"
    SQS_MESSAGE_BODY="TEST"
    aws sqs send-message \
      --queue-url "${SQS_QUEUE_URL}" \
      --message-body "${SQS_MESSAGE_BODY}"
    MESSAGE_CNT=$( \
      aws sqs get-queue-attributes \
        --queue-url ${SQS_QUEUE_URL} \
        --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible ApproximateNumberOfMessagesDelayed \
        --query 'Attributes.[ApproximateNumberOfMessages,ApproximateNumberOfMessagesNotVisible,ApproximateNumberOfMessagesDelayed]' \
        | jq '.[] | tonumber' | jq --slurp 'add'
    )
    echo "MESSAGE_CNT: ${SQS_QUEUE_NAME}: ${MESSAGE_CNT}"
  fi
}

create_sqs_message "${SQS_QUEUE_NAME}"

exit 0