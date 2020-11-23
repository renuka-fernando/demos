#!/bin/bash

# Apply HPA congis
apictl apply -f hpa-conf.yaml
kubectl apply -f prometheus-adapter-configs.yaml

# Backend services
apictl apply -f products-target-ep.yaml
apictl apply -f orders-target-ep.yaml

# Shared API
apictl add api -n abc-shopping-api \
    --from-file=products-swagger.yaml \
    --from-file=orders-swagger.yaml \
    --override

# Prometheus service monitors
apictl apply -f prometheus-service-monitors/
