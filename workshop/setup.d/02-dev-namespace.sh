#!/bin/bash
set -x
set +e

REGISTRY_USER=${HARBOR_USER:-admin}
REGISTRY_PASSWORD=$HARBOR_PASSWORD kp secret create registry-credentials --registry 192.168.49.2:30002 --registry-user $REGISTRY_USER
