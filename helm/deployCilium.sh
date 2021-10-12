#!/bin/bash

# Usage: ./deployCilium.sh kube-system "1.9.7+2"

VERSION=$2
NAMESPACE=$1
helm upgrade --install cilium cilium/cilium --version $VERSION \
  --namespace $NAMESPACE -f gke.helm.values.yaml