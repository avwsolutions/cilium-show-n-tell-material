#!/bin/bash
for x in `ls -1 *rule.yaml` ; do
  kubectl apply -n web -f $x
done