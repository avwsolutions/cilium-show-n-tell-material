#!/bin/bash
for rule in `kubectl get cnp -n web | grep -v NAME | awk '{print $1}'` ; do
  kubectl delete cnp $rule -n web
done