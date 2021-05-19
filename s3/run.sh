#!/bin/bash

set -e
echo "Invoking create bucket end point"

tags={"created-by" : "lazy-terraform", \
      "owner" : "'"$6"'","purpose" : "'"$7"'","team" : "'"$8"'" \
      "/octopus/project_name" : "'"$10"'", "/octopus/space" : "'"$9"'" \
    }

wget --content-on-error -O - --header="Content-Type:application/json" --header='x-api-key: '"$2"'' \
 --post-data '{"options": { "Bucket" : "'"$5"'"}, \
 "CreateBucketConfiguration": { "LocationConstraint":"'"$3"'" }, "tags": "'"$tags"'" }' "$1"/profiles/devops/s344

echo "Response Body: $HTTP_RESPONSE"
