#!/bin/bash
set -e
echo "update tags"

wget --content-on-error -O - --method=put --header="Content-Type:application/json" --header='x-api-key: '"$2"'' \
 --body-file=tags.json  "$1"/profiles/"$3"/s3/"$4/tags"



