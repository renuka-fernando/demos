#!/bin/bash

# setup ingress
# https://kubernetes.github.io/ingress-nginx/deploy/#gce-gke
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.1/deploy/static/provider/cloud/deploy.yaml

# install API Operator in GCR
apictl install api-operator \
    --from-file api-operator-controller-artifacts-1.2.0 \
    --registry-type GCR \
    --key-file /Users/renuka/softwares/apim-kube-svc-acc-key.json

# configure metrics server, install this if using a local cluster
# apictl apply -f prometheus-configs/metrics-server/metrics-server-components-0.3.6.yaml

# Install Prometheus Operator (version 0.39 for this sample)
apictl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/v0.39.0/bundle.yaml

# Create a Prometheus instance
apictl apply -f prometheus-configs/prometheus/
# Access prometheus via http://<NODE-IP>:30900/graph

# Install Prometheus Adapter
apictl create namespace custom-metrics
apictl create secret generic cm-adapter-serving-certs \
        --from-file=serving-ca.crt=prometheus-configs/prometheus-adapter/certs/serving-ca.crt \
        --from-file=serving-ca.key=prometheus-configs/prometheus-adapter/certs/serving-ca.key \
        -n custom-metrics
apictl apply -f prometheus-configs/prometheus-adapter/
# Check Prometheus Adapter installation
# apictl get --raw /apis/custom.metrics.k8s.io/v1beta1