#!/bin/sh

cd `dirname $0`

BASENAME=$(basename $0)
FILENAME=${BASENAME%.*}
ENV_TYPE=${FILENAME##*.}

BUCKET_NAME=$(cat ${ENV_TYPE}-parameters.json | jq -r '.Parameters[] | select(.ParameterKey == "ArtifactS3Bucket").ParameterValue')

ARTIFACT_NAME=code-lambda-$(cat ${ENV_TYPE}-parameters.json | jq -r '.Parameters[] | select(.ParameterKey == "LambdaName").ParameterValue')

aws s3 cp ${ARTIFACT_NAME}.zip s3://${BUCKET_NAME}/${ARTIFACT_NAME}.zip

exit 0