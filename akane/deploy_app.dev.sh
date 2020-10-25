#!/bin/sh

cd `dirname $0`

BASENAME=$(basename $0)
FILENAME=${BASENAME%.*}
ENV_TYPE=${FILENAME##*.}

APP_DIR=app
S3_DIR=s3-app/

BUCKET_NAME=$(cat ${S3_DIR}${ENV_TYPE}-parameters.json | jq -r '.Parameters[] | select(.ParameterKey == "AppS3Bucket").ParameterValue')

cd ${APP_DIR}

yarn install

yarn build-dev

aws s3 cp build s3://${BUCKET_NAME} --recursive

exit 0