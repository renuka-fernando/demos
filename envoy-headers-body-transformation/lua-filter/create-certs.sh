#!/bin/bash

CA_DOMAIN=mediation-service

mkdir certs
cd certs

# Root CA
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 \
    -subj "/O=${CA_DOMAIN} Inc./CN=${CA_DOMAIN}" \
    -keyout ca.key \
    -out ca.crt

