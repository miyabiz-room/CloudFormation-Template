#!/bin/sh

set -e

if [ $# -ne 2 ]; then
    echo " --- \033[0;31m [ERROR]: The following arguments are required \033[0;39m --- "
    echo "      \033[0;33m$0 <URL> <API_KEY>\033[0;39m"
    echo "      \033[0;33m<URL> Example: https://{custom_daomin}/v1/whisper\033[0;39m"
    exit 1
fi

cd `dirname $0`

echo " --- \033[0;33m TEST APIGW \033[0;39m --- "

URL=$1
API_KEY=$2

curl -X GET -H 'Content-Type: application/json' \
-H "x-api-key: ${API_KEY}" \
"${URL}"

exit 0