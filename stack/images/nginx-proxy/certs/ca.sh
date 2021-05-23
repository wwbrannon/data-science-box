#!/bin/bash

set -e

mkdir -p output
cd output

#
# Make a CA
#

if [[ -e ca.key ]] && [[ -e ca.crt ]]; then
    echo "ca.key and ca.crt exist; skipping"
    exit 0
fi

openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 365 \
            -out ca.crt -subj "/C=US/CN=wwbrannonCA"

