# Adaptive scaling of Microgateways on Kubernetes

## Steps

### 1. Installing API Operator and Prometheus

Installing API Operator 1.2.0 in ingress mode. The following setup script also installing NGINX ingress controller,
Prometheus and Prometheus Adapter.

```sh
./setup.sh
```

### 2. Scenario 1 - Shared Gateway

Create APIs
```sh
cd scenario-1-shared-gateway

./apply-configs.sh
```

Add ingress address to `/etc/hosts`.
```
<ADDRESS>    mgw.ingress.wso2.com
```

Test API
```sh
./test-api.sh
```

Run JMeter script to simulate requests
```sh
jmeter -t http-requests.jmx -n
```

Watch HPAs
```sh
kubectl get hpa -w
```

Clean Up
```sh
./cleanup.sh
cd ..
```

### 3. Scenario 2

Create APIs
```sh
cd scenario-2

./create-api-crd.sh
```

Add ingress address to `/etc/hosts`.
```
<ADDRESS>    mgw.ingress.wso2.com
```

Test API
```sh
./test-api.sh
```

Run JMeter script to simulate requests
```sh
jmeter -t http-requests.jmx -n
```

Watch HPAs
```sh
kubectl get hpa -w
```

Clean Up
```sh
./cleanup.sh
cd ..
```