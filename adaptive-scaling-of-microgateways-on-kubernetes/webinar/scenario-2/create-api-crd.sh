#!/bin/bash

apictl add api -n products-api \
    --from-file=products-swagger.yaml \
    --override


apictl add api -n orders-api \
    --from-file=orders-swagger.yaml \
    --override