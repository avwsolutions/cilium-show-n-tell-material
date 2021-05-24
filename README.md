
## Prerequisites

- Use the Cluster CIDR that we have extracting during Terraform completion.

## Deploy cilium

### Add Helm repository

First we need to add the repo

```
helm repo add cilium https://helm.cilium.io/
```

### Execute deployment
10.24.0.0/14
```
helm install cilium cilium/cilium --version 1.10.0 \
  --namespace kube-system \
  --set nativeRoutingCIDR=10.24.0.0/14 \
  --values helm/cilium.gke.values.yaml
```

