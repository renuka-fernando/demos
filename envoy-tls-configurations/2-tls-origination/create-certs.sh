#!/bin/bash

# Server Certs (for envoy listener)
SERVER_CA_DOMAIN=my.server.ca.com
SERVER_DOMAIN=ingress.foo.com

# Client Certs (for envoy cluster) and Backend Service Certs (Products HTTPS)
CLIENT_CA_DOMAIN=my.client.ca.com
CLIENT_DOMAIN=localhost
KEYSTORE_PASSWORD=admin1234

rm -rfd certs
mkdir certs
cd certs


# Server Certs (for envoy listener)
## Root CA
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 \
    -subj "/O=${SERVER_CA_DOMAIN} Inc./CN=${SERVER_CA_DOMAIN}" \
    -keyout server_ca.key \
    -out server_ca.crt

## Server Certs singned by CA
openssl req -newkey rsa:2048 -nodes \
    -subj "/CN=${SERVER_DOMAIN}/O=${SERVER_DOMAIN} organization" \
    -keyout server.key \
    -out server.csr

openssl x509 -req -days 365 \
    -CA server_ca.crt -CAkey server_ca.key -set_serial 0 \
    -in server.csr -out server.crt



# Client Certs (for envoy cluster) and Backend Service Certs (Products HTTPS)
mkdir products-https
cd products-https

## Root CA
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 \
    -subj "/O=${CLIENT_CA_DOMAIN} Inc./CN=${CLIENT_CA_DOMAIN}" \
    -keyout client_ca.key \
    -out client_ca.crt

## Server Certs singned by CA
openssl req -newkey rsa:2048 -nodes \
    -subj "/CN=${CLIENT_DOMAIN}/O=${CLIENT_DOMAIN} organization" \
    -keyout client.key \
    -out client.csr

openssl x509 -req -days 365 \
    -CA client_ca.crt -CAkey client_ca.key -set_serial 0 \
    -in client.csr -out client.crt

openssl pkcs12 -export \
    -out keystore.p12 \
    -in client.crt \
    -inkey client.key \
    -passout pass:${KEYSTORE_PASSWORD}
