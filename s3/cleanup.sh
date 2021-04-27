#!/bin/bash

set -e
echo "Bucket clean up started"

HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" -X DELETE -H "Content-Type: application/json" \
    -H "x-api-key: $2" \
    "$1"/profiles/"$3"/s3/"$4")

echo "$HTTP_RESPONSE"

HTTP_BODY="$(echo "$HTTP_RESPONSE" | sed -e 's/HTTPSTATUS\:.*//g')"
HTTP_STATUS_CODE="$(echo $HTTP_RESPONSE" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')"

echo "Response Body: $HTTP_BODY"
echo "Response Code: $HTTP_STATUS_CODE"

if [ ! "$HTTP_STATUS_CODE" -eq 200  ]; then
  echo "Error [HTTP status: $HTTP_STATUS_CODE]"
  exit 1
fi
echo "Bucket clean up done"
