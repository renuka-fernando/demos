#!/bin/bash

mkdir certs
cd certs

DOMAIN=ingress.foo.com

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 \
    -keyout serverkey.pem \
    -out servercert.pem \
    -subj "/CN=${DOMAIN}/O=${DOMAIN}"