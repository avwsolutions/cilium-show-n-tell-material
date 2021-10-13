# Demostrate Transparant Encryption with IPSEC

## Prerequisites

- Ensure that all cloud-vendor specific settings like Tunnel are set as expected. In our case with GKE this is `vxlan`

## Implementation

We start with creating the `encryption key`. During this example we will generate a `ipsec` keypair with random data and add this as secret named `cilium-ipsec-keys` to the cluster.

```
$ samples/transparant-encryption/createEncryption.sh
```

Now either update the `cilium-config` ConfigMap or add the correct value *(encryption > enabled > true)* to your Helm values file.
After this change restart your cilium daemonset and monitor the logs.

```
k rollout restart daemonset/cilium -n kube-system
```

Now we can validate the encryption itself with tcpdump, which we need to install the package first.

```
k exec ds/cilium -it -n kube-system -- bash
apt-get update
apt-get -y install tcpdump
```

Now exec tcpdump.

```
k exec ds/cilium -it -n kube-system -- tcpdump -n -i cilium_vxlan
```

Analyzing the traffic we can learn packets are successfully encrypted during transit.