#!/usr/bin/env bash

kubectl port-forward svc/workload 8443 &
sleep 1s

curl -k https://localhost:8443/v1/show

pkill -P $$
