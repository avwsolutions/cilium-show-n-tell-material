# Demostrate ClusterMesh with Load-balancing and Service Discovery

## Prerequisites

- Ensure that both clusters have network connectivity, especially for inter-cluster communication see [firewall requirements]](https://docs.cilium.io/en/latest/operations/system_requirements/#firewall-requirements).
- Ensure that both `PodCIDRs` are not overlapping each other.
- We strongly suggest to either use `transparant encryption` or other `VPN tunnel` between the clusters to ensure data in transit protection.

## Implementation

To run the Cilium `CLI` commands quickly we store our contexts for both `Kubernetes` clusters as variables.

```
CONTEXT_1=`k config current-context`
# Don't forget to switch your context or run `gcloud 
CONTEXT_2=`k config current-context`
```

Now that we have stored both `$CONTEXT_1` and `$CONTEXT_2`, we can start installing Cilium on `cluster-1`. We are going to install this using the `CLI`. Ensure that all Pods are *up-and-running* again.

```
k config use-context $CONTEXT_1
```
```
cilium install --cluster-name cluster-1 --cluster-id 1
```

After installation we are going to validate the `cilium-config` to ensure both `cluster-name` and `cluster-id` are set correctly. You can update these values with `edit`, but they require you to restart cilium with `k rollout restart ds/cilium -n kube-system`.

Use the following example to list the contents of the ConfigMap

```
k get cm cilium-config -n kube-system -o yaml
```

Now repeat the steps above for `cluster-2`.

```
k config use-context $CONTEXT_2
```
```
cilium install --cluster-name cluster-2 --cluster-id 2
```

Now that cilium is running on both clusters we can enable the `ClusterMesh` service. This API service is going to run on port `2379`. During this demo on **GKE** this will be exposed using a `LoadBalancer` based service. Other Kubernetes implementations can also use a `NodePort`.

```
cilium clustermesh enable --context $CONTEXT_1
cilium clustermesh enable --context $CONTEXT_2
```

After you have enabled the  `ClusterMesh` feature both a Deployment/Replicaset/Pod and service are created, see ` get all -n kube-system | grep clustermesh`.

Still one step needed to connect both clusters into one mesh aka `ClusterMesh`. This is what we can achieve with one single command.

```
cilium clustermesh connect --context $CONTEXT_1 --destination-context $CONTEXT_2
```

After a successfull connect we can validate how everything is running as expected. We can inspect the `logs` or validate one of the cilium Pods.

Do we have both clusters available? cluster health should output `2/2 reachable`.
 
```
k exec ds/cilium -n kube-system -it -- cilium status [--verbose]
```

Other thing to validate is if both cluster nodes are visible with.

```
k exec ds/cilium -n kube-system -it -- cilium node list
```

Optionally you can use the `cilium connectivity test`. You can execute this by the following Command.

```
cilium connectivity test --context $CONTEXT_1 --multi-cluster $CONTEXT_2
```

Now that have validated the installation we can start deploying one of the `samples` from the Cilium community, but first let's explain a little bit about these manifests. Use the following guidelines to enable a `global service`. To implement such we have to ensure that *ClusterMesh* services have the `io.cilium/global-service: "true"` annotation set. Optionally you can set the following annotation `io.cilium/shared-service: "false"` to ensure that traffic is only balanced to remote clusters.

We can now start deploying the sample material.

On `cluster-1` apply the following manifests to activate the sample `nginx` service.

```
k apply -f samples/cluster-mesh/rebel-base-global-shared.yaml
k apply -f samples/cluster-mesh/cluster1.yaml
```

For `cluster-2` repeat the steps with the manifests below.

```
k apply -f samples/cluster-mesh/rebel-base-global-shared.yaml
k apply -f samples/cluster-mesh/cluster2.yaml
```

Great we can now test the web service output with responses from both clusters.
```
k run startrooper --image=radial/busyboxplus:curl -it --rm --restart Never -- /bin/sh -c 'for i in $(seq 1 20); do curl http://rebel-base/; done'
```

Do you want more information? Just visit the [Cilium documentation](https://docs.cilium.io/en/latest/gettingstarted/clustermesh/services/).