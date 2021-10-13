# Demostrate how to apply your first Network policy samples

## Prerequisites

- Alway helpful is an additional browser tab to [Policy editor](https://editor.cilium.io/)

## Implementation


We will start with a L7 policy. This policy blocks all 'world' tagged traffic that tries to do a GET on the '/' endpoint. Let's look what will happen.

```
k apply -f samples/network-policies/block-web-traffic.yaml
```

This was just an example. Now open `hubble` to look into the packages that where DROPPED.

```
cilium hubble ui
```

We can also use the `Hubble CLI` for this.

```
# First forward the hubble port from local to cluster port. 
cilium hubble port-forward &

hubble status
hubble observe -f
```

Next we can apply a `least priviledge` policy set to our web application. This is one policy that rules them all, but still with overview.

```
k apply -f samples/network-policies/online-boutique/all-in-one/online-boutique-all-in-one.yaml -n web
```

Additional we have created a full blown set.
```
samples/network-policies/online-boutique/activate-cilium-network-policies.sh
```

Remove the policies with this script
```
samples/network-policies/online-boutique/delete-cilium-network-policies.sh
```

Now monitor again what happens with your web traffic.