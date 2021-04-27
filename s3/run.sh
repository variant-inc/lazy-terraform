#!/bin/bash

set -e
echo "Invoking create bucket end point"

HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" -X POST -H "Content-Type: application/json" \
    -H "x-api-key: $2" \
    -d '{"options": { "Bucket" : "'"$5"'"}, "tags": { "owner" : "'"$6"'","purpose" : "'"$7"'","team" : "'"$8"'"   } }' \
    "$1"/profiles/"$4"/regions/"$3"/s3)

echo "$HTTP_RESPONSE"

HTTP_BODY="$(echo "$HTTP_RESPONSE" | sed -e 's/HTTPSTATUS\:.*//g')"
HTTP_STATUS_CODE="$(echo "$HTTP_RESPONSE" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')"

echo "Response Body: $HTTP_BODY"
echo "Response Code: $HTTP_STATUS_CODE"

if [ ! "$HTTP_STATUS_CODE" -eq 200  ]; then
  echo "Error [HTTP status: $HTTP_STATUS_CODE]"
  exit 1
fi

