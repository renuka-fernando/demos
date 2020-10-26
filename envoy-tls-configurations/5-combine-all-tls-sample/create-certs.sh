#!/bin/bash

rm -rfd certs

create_root_ca_cert() {
    CA_DOMAIN=$1
    OUT_KEY=$2
    OUT_CERT=$3

    openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 \
        -subj "/O=${CA_DOMAIN} Inc./CN=${CA_DOMAIN}" \
        -keyout $OUT_KEY \
        -out $OUT_CERT
}

create_signed_cert() {
    DOMAIN=$1
    CA_KEY=$2
    CA_CERT=$3
    OUT_KEY=$4
    OUT_CERT=$5
    CSR=$6

    openssl req -newkey rsa:2048 -nodes \
        -subj "/CN=${DOMAIN}/O=${DOMAIN} organization" \
        -keyout $OUT_KEY \
        -out $CSR

    openssl x509 -req -days 365 \
        -CA $CA_CERT -CAkey $CA_KEY -set_serial 0 \
        -in $CSR -out $OUT_CERT
}

# 1. mTLS
## server
mkdir -p certs/mtls/server
create_root_ca_cert mtls.ca.com certs/mtls/server/ca.key certs/mtls/server/ca.crt
create_signed_cert mtls.ingress.com certs/mtls/server/ca.key certs/mtls/server/ca.crt \
    certs/mtls/server/server.key certs/mtls/server/server.crt certs/mtls/server/server.csr

## client
mkdir -p certs/mtls/client
create_root_ca_cert mtls.ca.com certs/mtls/client/ca.key certs/mtls/client/ca.crt
create_signed_cert mtls.ingress.com certs/mtls/client/ca.key certs/mtls/client/ca.crt \
    certs/mtls/client/server.key certs/mtls/client/server.crt certs/mtls/client/server.csr

# 2. TLS
mkdir -p certs/tls
create_root_ca_cert tls.ca.com certs/tls/ca.key certs/tls/ca.crt
create_signed_cert tls.ingress.com certs/tls/ca.key certs/tls/ca.crt \
    certs/tls/server.key certs/tls/server.crt certs/tls/server.csr

# 3. Origination
## Server Certs (for envoy listener)
mkdir -p certs/origination
create_root_ca_cert origination.ca.com certs/origination/ca.key certs/origination/ca.crt
create_signed_cert origination.ingress.com certs/origination/ca.key certs/origination/ca.crt \
    certs/origination/server.key certs/origination/server.crt certs/origination/server.csr
## Client Certs (for envoy cluster) and Backend Service Certs (Products HTTPS)
mkdir -p certs/origination/products-https
create_root_ca_cert client.ca.com certs/origination/products-https/ca.key certs/origination/products-https/ca.crt
create_signed_cert passthrough.ingress.com certs/origination/products-https/ca.key certs/origination/products-https/ca.crt \
    certs/origination/products-https/client.key certs/origination/products-https/client.crt certs/origination/products-https/client.csr
## pkcs12 for java backend
KEYSTORE_PASSWORD=admin1234
openssl pkcs12 -export \
    -out certs/origination/products-https/keystore.p12 \
    -in certs/origination/products-https/client.crt \
    -inkey certs/origination/products-https/client.key \
    -passout pass:${KEYSTORE_PASSWORD}