# Demostrate ClusterMesh with suport of External Workloads

## Prerequisites

- Ensure that both VM and cluster have network connectivity, especially for inter-cluster communication see [firewall requirements]](https://docs.cilium.io/en/latest/operations/system_requirements/#firewall-requirements).
- Ensure that both `PodCIDR / IP` are not overlapping each other.

## Implementation

We start with setting the correct `tunnel` type, which must be `vxlan`.

```
k get cm cilium-config -n kube-system -o yaml | grep tunnel
```

edit and set `tunnel: vxlan` (instead of Disabled) and restart the cilium daemonset.

```
 k rollout restart daemonset/cilium -n kube-system
```

Now we can start creating our first external workload called `oracle` and we assign a small cidr range that is used within the cluster.

```
cilium clustermesh vm create oracle -n default --ipv4-alloc-cidr 10.192.1.0/30
```

Check if the registration went succesful
```
cilium clustermesh vm status
```

Now we need to generate the deployment script, which is specific for our cluster.

```
cilium clustermesh vm install install-external-workload.sh
```

Either download or upload the script 'install-external-workload.sh' to the VM and ensure Docker is installed.

Install docker on your VM
```
sudo apt-get update
sudo apt install docker.io
docker --version
```

Now execute the install script and wait for connection/completion.

```
sudo ./install-external-workloads.sh
```

After the installation we can validate if the VM has been added to the `node list`.

```
k exec ds/cilium -n kube-system -it -- cilium node list
```

Other commands we can use are `k get cew` for all external workloads or `k get cep` to see the specific external endpoint.

Another way to validate the connectivity is to run a ping towards clustermesh API server.

```
ping $(cilium service list get -o jsonpath='{[?(@.spec.flags.name=="clustermesh-apiserver")].spec.backend-addresses[0].ip}')
```

For testing purposes you can apply the following manifest, which enables access to the ClusterMesh API Server. After applying this manifest the ping should still work.

```
k apply -f samples/external-workloads/clustermesh.yaml
```

Just update the name in the manifest to `db2` and you will see that the ping isn't working anymore due network restrictions. Below the snippet to change.

```
  - fromEndpoints:
    - matchLabels:
        io.kubernetes.pod.name: db2
```