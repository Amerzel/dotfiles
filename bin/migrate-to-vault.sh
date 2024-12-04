#!/usr/bin/env bash

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <kubernetes_cluster_name> <kubernetes_namespace> <kubernetes_secret_name>"
    echo
    exit 1
fi

cluster=$1
namespace=$2
secret=$3

if [[ $cluster == qa* ]] || [[ $cluster == dev* ]]; then
    environment="development"
else
    environment="production"
fi

SECRETS=$(kubectl --context ${cluster} -n ${namespace} get secret ${secret} -o json)

vault_command="vault kv put global/kv/kubernetes/${namespace}/environments/${environment}/${secret}"

for key in $(jq -r '.data | keys | .[]'<<< "$SECRETS"); do
    value=$(jq -r ".data.${key}"<<< "$SECRETS" | base64 -d)
    vault_command="${vault_command} ${key}='${value}'"
done

echo "${vault_command}"
