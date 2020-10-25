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

amplify init
amplify import auth
amplify codegen remove
api_id=$(aws appsync list-graphql-apis --query 'graphqlApis[]' | jq -r '.[] | select (.name=="akane-dev-appsync-graphql-api") | .apiId')
amplify add codegen --apiId ${api_id}
amplify codegen
amplify push

yarn build

aws s3 cp build s3://${BUCKET_NAME} --recursive

exit 0
