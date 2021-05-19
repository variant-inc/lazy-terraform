#!/bin/bash

set -e
echo "Invoking create bucket end point"

wget --content-on-error -O - --header="Content-Type:application/json" --header='x-api-key: '"$2"'' \
 --post-data '{"options": { "Bucket" : "'"$5"'"}, 
 "CreateBucketConfiguration": { "LocationConstraint":"'"$3"'" }, "tags": { "owner" : "'"$6"'","purpose" : "'"$7"'","team" : "'"$8"'" }}' "$1"/profiles/devops/s3

echo "Response Body: $HTTP_RESPONSE"
