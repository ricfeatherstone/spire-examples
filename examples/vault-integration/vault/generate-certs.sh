#!/usr/bin/env bash

if [ ! -d bin ]; then
  mkdir bin
fi

if [ ! -f bin/cfssl ]; then
  curl -Lo bin/cfssl https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssl_1.6.1_linux_amd64
  curl -Lo bin/cfssljson https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssljson_1.6.1_linux_amd64
  chmod +x bin/cfssl bin/cfssljson
fi

if [ ! -f ca.pem ]; then
  cfssl gencert -initca certs/ca-csr.json | cfssljson -bare certs/ca
  cfssl gencert \
      -ca=certs/ca.pem \
      -ca-key=certs/ca-key.pem \
      -config=certs/ca-config.json \
      -profile=both \
      certs/vault-csr.json | cfssljson -bare certs/vault
fi

for dest in config ../workload; do
  cp certs/ca.pem $dest
done

cp certs/vault.pem certs/vault-key.pem config
