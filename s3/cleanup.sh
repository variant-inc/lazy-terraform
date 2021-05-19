#!/bin/bash
set -e
echo "Invoking create bucket end point"
wget --content-on-error -O - --header="Content-Type:application/json" --header='x-api-key: '"$2"'' --method=delete "$1"/profiles/"$3"/s3/"$4"


