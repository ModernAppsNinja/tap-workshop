#!/bin/bash
set -x
set +e

REGISTRY_USER=${HARBOR_USER:-admin}
REGISTRY_PASSWORD=$HARBOR_PASSWORD kp secret create registry-credentials --registry harbor.${INGRESS_DOMAIN} --registry-user $REGISTRY_USER

printf %b "$KUBE_CONFIG" > config
envsubst < config > .kube/config

envsubst < /home/eduk8s/install/rbac/app-editor.yaml | kubectl apply -f-