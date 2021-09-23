# K8s Deployment

## 1. Build Ext-Service

```sh
bal build --offline --cloud=docker ext-bal-service
```

## 2. K8s cluster
```sh
kubectl create ns envoy
kubectl apply -k k8s
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
