#!/bin/bash

WEBROOT=$1
shift

DOMAINS=""
while (("$#")); do
    DOMAINS="$DOMAINS -d $1"
    shift
done

if [ -z $WEBROOT ] || [ -z $DOMAINS ]; then
    echo "bad arguments."
    echo "usage: $0 <path_to_webroot> <domains...>"
    echo ""
    exit 1
fi

echo certbot certonly --webroot -w $WEBROOT $DOMAINS
