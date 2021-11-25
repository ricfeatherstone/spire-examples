#!/usr/bin/env bash

kubectl -n spire exec $(kubectl -n spire get po -l=app.kubernetes.io/name=spire-server -oname) -- \
    /opt/spire/bin/spire-server entry create \
    -spiffeID spiffe://example.org/agents/spire \
    -selector k8s_psat:cluster:demo-cluster \
    -selector k8s_psat:agent_ns:spire \
    -selector k8s_psat:agent_sa:spire-agent \
    -node

kubectl -n spire exec $(kubectl -n spire get po -l=app.kubernetes.io/name=spire-server -oname) -- \
    /opt/spire/bin/spire-server entry create \
    -spiffeID spiffe://example.org/workload/default \
    -parentID spiffe://example.org/agents/spire \
    -selector k8s:ns:default \
    -selector k8s:sa:workload \
		-dns workload.example.org
