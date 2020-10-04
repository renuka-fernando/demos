#!/bin/bash

apictl apply -f products-target-ep.yaml
apictl apply -f orders-target-ep.yaml

apictl add api -n abc-shopping-api \
    --from-file=products-swagger.yaml \
    --from-file=orders-swagger.yaml \
    --override

apictl apply -f prometheus-service-monitors/
