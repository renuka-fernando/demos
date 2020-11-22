#!/bin/bash

apictl delete api abc-shopping-api
apictl delete targetendpoint orders-ms products-ms
apictl delete -f prometheus-service-monitors/