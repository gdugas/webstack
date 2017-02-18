#!/bin/bash

WEBROOT=$1
shift

DOMAINS=""
while (("$#")); do
    DOMAINS="$DOMAINS -d $1"
    shift
done


echo certbot certonly --webroot -w $WEBROOT $DOMAINS
