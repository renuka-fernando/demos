#!/bin/bash

CA_DOMAIN=my.ca.com
DOMAIN=ingress.foo.com

# Server Certs
mkdir -p certs/server
cd certs/server

# Root CA
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 \
    -subj "/O=${CA_DOMAIN} Inc./CN=${CA_DOMAIN}" \
    -keyout ca.key \
    -out ca.crt


# Server Certs singned by CA
openssl req -newkey rsa:2048 -nodes \
    -subj "/CN=${DOMAIN}/O=${DOMAIN} organization" \
    -keyout server.key \
    -out server.csr

openssl x509 -req -days 365 \
    -CA ca.crt -CAkey ca.key -set_serial 0 \
    -in server.csr -out server.crt

cd ../../


# Client Certs
mkdir -p certs/client
cd certs/client

# Root CA
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 \
    -subj "/O=${CA_DOMAIN} Inc./CN=${CA_DOMAIN}" \
    -keyout ca.key \
    -out ca.crt


# Server Certs singned by CA
openssl req -newkey rsa:2048 -nodes \
    -subj "/CN=${DOMAIN}/O=${DOMAIN} organization" \
    -keyout server.key \
    -out server.csr

openssl x509 -req -days 365 \
    -CA ca.crt -CAkey ca.key -set_serial 0 \
    -in server.csr -out server.crt
