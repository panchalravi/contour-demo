#!/bin/bash

if [[ $# == 0 ]]; then
  echo "Usage: $0 HOSTNAME" >&2
  echo "" >&2
  echo "This script creates self-signed CA and Domain TLS certificates for given hostname." >&2
  exit 1
fi

host="$1"

# Create private key for CA
openssl genrsa -out ca.key 4096
# Create CSR using the private key
openssl req -new -key ca.key -sha256 -subj "/CN=CA" -out ca.csr
# Self sign the csr using its own private key
openssl x509 -req -sha256 -in ca.csr -signkey ca.key -CAcreateserial  -out ca.crt -days 1000

# Create private key for server
openssl genrsa -out server.key 4096
# Create CSR
openssl req -new -key server.key -sha256 -subj "/C=SG/ST=SG/L=Singapore/O=GEL/CN=${host}" -out server.csr
# Sign the certificate using CA key
openssl x509 -req -in server.csr -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial  -out server.crt -extensions v3_req -days 1000
