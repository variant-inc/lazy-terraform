#!/bin/bash
set -e
echo "Invoking create bucket end point"
wget --content-on-error -O - --header="Content-Type:application/json" --header='x-api-key: '"$LAZY_API_KEY"'' --method=delete "$LAZY_API_HOST"/profiles/"$S3_PROFILE"/"$1"


