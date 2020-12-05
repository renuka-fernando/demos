#!/bin/bash

# apply ingress 1 first
kubectl apply -f ingress-1.yaml
sleep 1
kubectl apply -f ingress-2.yaml

for name in {1..5}
do
    sed -e "s/\${NAME}/${name}/" backend/backend-template.yaml | kubectl apply -f -
done