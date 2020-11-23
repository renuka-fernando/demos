#!/bin/bash

# Install ingress controller - NGINX
# https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/cloud/deploy.yaml

# Install API Operator in ingress mode and using DockerHub
# Enabled Observability
# Setted ingressHostName as "mgw.ingress.wso2.com"
apictl install api-operator \
    --from-file api-operator-controller-artifacts-1.2.0 \
    --registry-type DOCKER_HUB \
    --repository=<REPOSITORY> \
    --username=<USER_NAME> \
    --password=<PASSWORD>

# configure metrics server, install this if using a local cluster
# apictl apply -f prometheus-configs/metrics-server/metrics-server-components-0.3.6.yaml

# Install Prometheus Operator (version 0.39 for this sample)
apictl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/v0.39.0/bundle.yaml

# Create a Prometheus instance
apictl apply -f prometheus-configs/prometheus/
# Access prometheus via http://<NODE-IP>:30900/graph

# Install Metrics Server to collects resource metrics (optional for GKE and other cloud vendors)
apictl apply -f metrics-server/metrics-server-components-0.3.6.yaml

# Install Prometheus Adapter
apictl create namespace custom-metrics
apictl create secret generic cm-adapter-serving-certs \
        --from-file=serving-ca.crt=prometheus-configs/prometheus-adapter/certs/serving-ca.crt \
        --from-file=serving-ca.key=prometheus-configs/prometheus-adapter/certs/serving-ca.key \
        -n custom-metrics
apictl apply -f prometheus-configs/prometheus-adapter/
# Check Prometheus Adapter installation
# apictl get --raw /apis/custom.metrics.k8s.io/v1beta1