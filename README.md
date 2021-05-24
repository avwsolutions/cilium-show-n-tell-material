
## Prerequisites

- Use the Cluster CIDR that we have extracting during Terraform completion.

## Deploy cilium

### Add Helm repository

First we need to add the repo

```
helm repo add cilium https://helm.cilium.io/
```

### Observability 

Apply the following `manifest` to have both `prometheus` and  `grafana` activated in the cluster. Both are configured for `cilium monitoring`.

```
kubectl apply -f cilium-monitoring.yaml
```

### Execute deployment

Deploy the following `chart` below to activate both `cilium` and `hubble`.

```
helm install cilium cilium/cilium --version 1.10.0 \
  --namespace kube-system \
  --set nativeRoutingCIDR=10.24.0.0/14 \
  --values helm/cilium.gke.values.yaml
```

