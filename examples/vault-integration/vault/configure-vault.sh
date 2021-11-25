#!/usr/bin/env bash

ISSUER=https://kubernetes.default.svc.cluster.local
VAULT_POD=$(kubectl get po -n vault -l=app.kubernetes.io/name=vault -oname)
HOST_IP=$(kubectl get $VAULT_POD -n vault -o"jsonpath={.status.hostIP}")

kubectl -n vault port-forward $VAULT_POD 8200 &
sleep 5s

export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_CACERT=certs/ca.pem

vault operator init -n=1 -t=1 -format=json > vault-init.json
vault operator unseal $(jq -r .unseal_keys_b64[0] < vault-init.json)

export VAULT_TOKEN=$(jq -r .root_token < vault-init.json)

vault secrets enable -path spiffe pki
vault secrets tune -max-lease-ttl=8760h spiffe
vault write spiffe/config/urls \
	issuing_certificates=https://$HOST_IP/v1/spiffe/ca \
  crl_distribution_points=https://$HOST_IP/v1/spiffe/crl

vault write -field certificate spiffe/root/generate/internal \
  common_name=example.org \
  key_type=ec \
  key_bits=256 > ca.crt

vault auth enable cert

vault write auth/cert/certs/spiffe \
  certificate=@ca.crt \
  allowed_common_names=*.example.org \
  allowed_uri_sans=spiffe://example.org/* \
  token_ttl=15m \
  token_max_ttl=1h

rm ca.crt

vault policy write spire-server -<<EOF
path "spiffe/root/sign-intermediate" {
  capabilities = [
    "update",
  ]
}
EOF

vault auth enable kubernetes
vault write auth/kubernetes/config \
      kubernetes_host=https://kubernetes.default.svc \
      issuer=$ISSUER
vault write auth/kubernetes/role/spire-server \
  bound_service_account_names=spire-server \
  bound_service_account_namespaces=spire \
  policies=spire-server

vault secrets enable -path secret kv-v2

vault kv put secret/workload foo=s3cr3t bar=tops3cr3t

vault policy write workload -<<EOF
path "secret/data/workload" {
  capabilities = [
    "read",
  ]
}
EOF

CERT_ACCESSOR=$(vault auth list -format=json | jq -r '."cert/".accessor')

ID=$(vault write -field=id identity/entity name=example.org/workload/default policies=workload)
vault write identity/entity-alias name=workload.example.org \
    canonical_id=$ID \
    mount_accessor=$CERT_ACCESSOR

pkill -P $$
