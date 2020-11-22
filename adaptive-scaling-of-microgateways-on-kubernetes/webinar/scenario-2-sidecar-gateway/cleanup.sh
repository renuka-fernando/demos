#!/bin/bash

apictl delete api products-api
apictl delete api orders-api
apictl delete targetendpoint orders-ms products-ms
apictl delete -f prometheus-service-monitors/