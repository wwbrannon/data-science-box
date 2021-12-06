#!/bin/bash

set -e

cd output

# First, subjectAltName config
cat << EOF > ssl.ext
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = matlaber1.media.mit.edu
DNS.2 = matlaber2.media.mit.edu
DNS.3 = matlaber3.media.mit.edu
DNS.4 = matlaber4.media.mit.edu
DNS.5 = matlaber5.media.mit.edu
DNS.6 = matlaber6.media.mit.edu
DNS.7 = matlaber7.media.mit.edu
DNS.8 = matlaber8.media.mit.edu
DNS.9 = matlaber9.media.mit.edu
DNS.10 = matlaber10.media.mit.edu
DNS.11 = matlaber11.media.mit.edu
DNS.12 = matlaber12.media.mit.edu
DNS.13 = matlaberp1.media.mit.edu
DNS.14 = matlaberp2.media.mit.edu
DNS.15 = matlaberp3.media.mit.edu
DNS.16 = matlaberp4.media.mit.edu
DNS.17 = matlaberp5.media.mit.edu
DNS.18 = matlaberp6.media.mit.edu
EOF

# Make the certificate
rm -f ssl.csr ssl.key ca.srl

openssl genrsa -out ssl.key 2048
openssl req -new -key ssl.key -out ssl.csr -subj "/C=US/CN=matlaber.media.mit.edu"
openssl x509 -req -in ssl.csr -CA ca.crt \
             -CAkey ca.key -CAcreateserial -out ssl.crt \
             -days 365 -sha256 -extfile ssl.ext

rm -f ssl.csr ssl.ext ca.srl

# link it for the nginx proxy
for i in 1 2 3 4 5 6 7 8 9 10 11 12 p1 p2 p3 p4 p5 p6; do
    ln -s ssl.crt matlaber$i.media.mit.edu.crt
    ln -s ssl.key matlaber$i.media.mit.edu.key
done

