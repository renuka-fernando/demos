#!/bin/bash

CA_DOMAIN=my.ca.com
DOMAIN=ingress.foo.com
KEYSTORE_PASSWORD=admin1234

rm -rfd certs
mkdir -p certs/products-https
cd certs/products-https

# Root CA
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 \
    -subj "/O=${CA_DOMAIN} Inc./CN=${CA_DOMAIN}" \
    -keyout ca.key \
    -out ca.crt

# Server Certs singned by CA
openssl req -newkey rsa:2048 -nodes \
    -subj "/CN=${DOMAIN}/O=${DOMAIN} organization" \
    -keyout client.key \
    -out client.csr

openssl x509 -req -days 365 \
    -CA ca.crt -CAkey ca.key -set_serial 0 \
    -in client.csr -out client.crt

openssl pkcs12 -export \
    -out keystore.p12 \
    -in client.crt \
    -inkey client.key \
    -passout pass:${KEYSTORE_PASSWORD}