
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

### Validate our deployment

:warning: : Ensure that you have installed both `Cilium CLI` and `Hubble CLI`. More information see [Getting started](https://docs.cilium.io/en/v1.10/gettingstarted/hubble_setup/#install-the-hubble-client).

First we will start with requesting the component status with `cilium status --wait`. Last thing to execute is an actual end-to-end test with `cilium connectivity test`.

### Deploy demo application

For this demostration we use the `Online Boutique`, which is a well-known `microservices-demo` application built for Google Cloud. Clone the repository and apply the `manifests`.

```
git clone git@github.com:GoogleCloudPlatform/microservices-demo.git
kubectl apply -f ./microservices-demo/release/kubernetes-manifests.yaml
```
