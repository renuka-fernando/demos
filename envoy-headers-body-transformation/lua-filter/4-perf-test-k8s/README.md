# K8s Deployment

## 1. Setup Jmeter

```sh
mkdir envoy-lua-perf
cd envoy-lua-perf
wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.4.1.tgz
tar -xzf apache-jmeter-5.4.1.tgz
rm apache-jmeter-5.4.1.tgz

cat  << EOF > source.sh
export PATH=$PATH:~/envoy-lua-perf/apache-jmeter-5.4.1/bin
EOF
```

```sh
source ~/envoy-lua-perf/source.sh
JVM_ARGS="-Xms4g -Xmx4g"
export JVM_ARGS
```

## 2. K8s cluster

```sh
kubectl apply -k k8s
```

OR

```sh
kustomize build k8s | k apply -f -
```

## 3. Jmeter Script

Update file path for request json object and the summery CSV file.

```sh
EXTERNAL_IP=<EXTERNAL_IP>
PATH=/lua
DURATION=1200

jmeter -n -t jmeter-script-1.jmx -JExternalIP=${EXTERNAL_IP} -JPort=80 \
    -JPath=${PATH} -JDuration=${DURATION} -JThreads=50 \
    -JSummaryCSV=~/jmeter-results/lua-summary.csv \
    -JPayload=/home/renuka/10485760B.json
```
```sh
PATH=/without
jmeter -n -t jmeter-script-1.jmx -JExternalIP=${EXTERNAL_IP} -JPort=80 \
    -JPath=${PATH} -JDuration=${DURATION} -JThreads=50 \
    -JSummaryCSV=~/jmeter-results/lua-summary.csv \
    -JPayload=/home/renuka/10485760B.json
```
```sh
PATH1=/lua
PATH2=/without
jmeter -n -t jmeter-script-1.jmx -JExternalIP=${EXTERNAL_IP} -JPort=80 \
    -JPath=${PATH1} -JDuration=${DURATION} -JThreads=50 \
    -JSummaryCSV=~/jmeter-results/lua-summary.csv \
    -JPayload=/home/renuka/10485760B.json & \
jmeter -n -t jmeter-script-1.jmx -JExternalIP=${EXTERNAL_IP} -JPort=80 \
    -JPath=${PATH2} -JDuration=${DURATION} -JThreads=50 \
    -JSummaryCSV=~/jmeter-results/lua-summary.csv \
    -JPayload=/home/renuka/10485760B.json & \
```

## 3. Test in Local

### 3.1. Build Ext-Service

```sh
bal build --offline --cloud=docker ext-bal-service
```

### 3.2. Run the Setup

```sh
bal run --offline ext-bal-service
```

```
docker compose up
```

### 3.2. Invoke
```sh
curl http://localhost:8080/lua \
    -H "content-type: application/json" \
    -H "additional: this should be removed" \
    -H "replace-this: wrong_value" \
    -d @../sample-payloads/sample.json
```


## G Cloud Setup

cd ~/envoy-lua-perf/demos/envoy-headers-body-transformation/lua-filter/4-perf-test-k8s
gcloud compute copy-files gke-apim-garner-demo-default-pool-bd8cde6f-1o6j:foo.txt foo.txt --zone=us-central1-c --project "apim-kube"
