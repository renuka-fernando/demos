# K8s Deployment

## 1. Build Ext-Service

```sh
bal build --offline --cloud=docker ext-bal-service
```

## 2. K8s cluster
```sh
kubectl apply -k k8s
```

OR

```sh
kustomize build k8s | k apply -f -
```

## 3. Test in Local

```sh
bal run --offline ext-bal-service
```

```
docker compose up
```

## 4. Invoke
```sh
curl http://localhost:8080/lua \
    -H "content-type: application/json" \
    -H "additional: this should be removed" \
    -H "replace-this: wrong_value" \
    -d @../sample-payloads/sample.json
```

## 5. Jmeter Script

Update file path for request json objecj and the summery CSV file.

```sh
jmeter -n -t jmeter-script-1.jmx
jmeter -n -t jmeter-script-2.jmx
jmeter -n -t jmeter-script-1.jmx & jmeter -n -t jmeter-script-2.jmx
```

For google cloud dir
source ~/envoy-lua-perf/source.sh
source ~/envoy/sources.sh
cd ~/envoy-lua-perf/demos/envoy-headers-body-transformation/lua-filter/4-perf-test-k8s
