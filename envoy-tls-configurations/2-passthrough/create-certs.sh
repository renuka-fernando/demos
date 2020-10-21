#!/bin/bash

DOMAIN=ingress.foo.com
KEYSTORE_PASSWORD=admin1234

rm -rfd certs
mkdir -p certs/products-https
cd certs/products-https

# create client certs for clusters
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 \
    -keyout clientkey.pem \
    -out clientcert.pem \
    -subj "/CN=${DOMAIN}/O=${DOMAIN}"

openssl pkcs12 -export \
    -out keystore.p12 \
    -in clientcert.pem \
    -inkey clientkey.pem \
    -passout pass:${KEYSTORE_PASSWORD}