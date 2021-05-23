#!/bin/bash

set -e

cd output

cat << EOF > ssl.ext
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
EOF

# Make the certificate
rm -f ssl.csr ssl.key ca.srl

openssl genrsa -out ssl.key 2048
openssl req -new -key ssl.key -out ssl.csr -subj "/C=US/CN=glasshouse.media.mit.edu"
openssl x509 -req -in ssl.csr -CA ca.crt \
             -CAkey ca.key -CAcreateserial -out ssl.crt \
             -days 365 -sha256 -extfile ssl.ext

rm -f ssl.csr ssl.ext ca.srl

ln -s ssl.key glasshouse.media.mit.edu.key
ln -s ssl.crt glasshouse.media.mit.edu.crt

