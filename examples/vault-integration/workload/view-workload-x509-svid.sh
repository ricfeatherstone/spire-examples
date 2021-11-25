#!/usr/bin/env bash

kubectl port-forward svc/workload 8443 &
sleep 1s

openssl s_client -connect localhost:8443 < /dev/null 2>/dev/null | openssl x509 -text -noout -in -

pkill -P $$
