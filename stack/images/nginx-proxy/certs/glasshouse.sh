#!/bin/bash

set -e

mkdir -p output
cd output

#
# Make a CA
#

rm -f CA.key CA.pem

openssl genrsa -out CA.key 2048
openssl req -x509 -new -nodes -key CA.key -sha256 -days 365 \
            -out CA.crt -subj "/C=US/CN=CA"

#
# Set up SSL cert
#

cat << EOF > ssl.ext
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
EOF

# Make the certificate
rm -f ssl.csr ssl.key CA.srl

openssl genrsa -out ssl.key 2048
openssl req -new -key ssl.key -out ssl.csr -subj "/C=US/CN=glasshouse.media.mit.edu"
openssl x509 -req -in ssl.csr -CA CA.crt \
             -CAkey CA.key -CAcreateserial -out ssl.crt \
             -days 365 -sha256 -extfile ssl.ext

rm -f ssl.csr ssl.ext CA.srl

ln -s ssl.key glasshouse.media.mit.edu.key
ln -s ssl.crt glasshouse.media.mit.edu.crt

