#!/bin/bash

kubectl delete -f .

for name in {1..5}
do
    sed -e "s/\${NAME}/${name}/" backend/backend-template.yaml | kubectl delete -f -
done