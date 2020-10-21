#!/bin/bash

SERVER_DOMAIN=ingress.foo.com
CLIENT_DOMAIN=localhost
KEYSTORE_PASSWORD=admin1234

rm -rfd certs
mkdir certs
cd certs

# create server certs for listeners
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 \
    -keyout serverkey.pem \
    -out servercert.pem \
    -subj "/CN=${SERVER_DOMAIN}/O=${SERVER_DOMAIN}"

# create client certs for clusters
mkdir products-https
cd products-https

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 \
    -keyout clientkey.pem \
    -out clientcert.pem \
    -subj "/CN=${CLIENT_DOMAIN}/O=${CLIENT_DOMAIN}"

openssl pkcs12 -export \
    -out keystore.p12 \
    -in clientcert.pem \
    -inkey clientkey.pem \
    -passout pass:${KEYSTORE_PASSWORD}