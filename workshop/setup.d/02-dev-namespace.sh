#!/bin/bash
set -x
set +e

REGISTRY_USER=${HARBOR_USER:-admin}
REGISTRY_PASSWORD=$HARBOR_PASSWORD kp secret create registry-credentials --registry harbor.${INGRESS_DOMAIN} --registry-user $REGISTRY_USER

kubectl get cm context -n $WORKSHOP_NAMESPACE -o jsonpath='{.data.config}' > .kube/config