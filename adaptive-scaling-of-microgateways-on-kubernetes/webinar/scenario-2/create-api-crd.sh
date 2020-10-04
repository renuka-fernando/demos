#!/bin/bash

# Apply HPA congis
apictl apply -f hpa-conf.yaml

# API 1
apictl apply -f products-target-ep.yaml

apictl add api -n products-api \
    --from-file=products-swagger.yaml \
    --override

# API 2
apictl apply -f orders-target-ep.yaml

apictl add api -n orders-api \
    --from-file=orders-swagger.yaml \
    --override

# Prometheus service monitors
apictl apply -f prometheus-service-monitors/
