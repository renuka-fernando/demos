#!/bin/bash

# Apply HPA congis
apictl apply -f hpa-conf.yaml
kubectl apply -f prometheus-adapter-configs.yaml

# API 1 - Products
apictl apply -f products-target-ep.yaml

apictl add api -n products-api \
    --from-file=products-swagger.yaml \
    --override

# API 2 - Orders
apictl apply -f orders-target-ep.yaml

apictl add api -n orders-api \
    --from-file=orders-swagger.yaml \
    --override

# Prometheus service monitors
apictl apply -f prometheus-service-monitors/
