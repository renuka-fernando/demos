# Transformations with Lua Filter

## Pre Req

- Docker
- Ballerina Swan Lake
## Build Mediation and Backend (Upstream) Services

Add following host entry (in `/etc/hosts`)

```
<YOUR_HOST_IP>   mediation-service
```

```sh
./create-certs.sh
./build.sh
```

## Test

### Mediation Service

Start the Sediation Service.

```sh
bal run mediation_service
```

#### JSON to XML convertion: handlerequest

```sh
curl https://mediation-service:9090/handlerequest -v \
    --cacert certs/ca.crt \
    -H "content-type: application/json" \
    -d '{"body": "eyJIZWxsbyI6IldvcmxkIn0K"}'
```

#### Chunking request: handlerequest_chunks

```sh
curl https://mediation-service:9090/handlerequest_chunks -v \
    --cacert certs/ca.crt \
    -H "content-type: application/json" \
    -d @sample-payloads/sample.json
```

#### Multiparts log: multipart

```sh
curl https://mediation-service:9090/multipart -v \
    --cacert certs/ca.crt \
    -H "content-type: multipart/form-data" \
    -F 'studentsJson={"students":[{"name":"Renuka"},{"name":"Menuka"}]};type=application/json' \
    -F 'helloXml="<hello>World</hello>";type=application/xml'
```

### Backend Service (Upstream)

Start the Sediation Service.

```sh
bal run backend_service
```

#### Log paylaod and headers

```sh
curl http://localhost:9080/post -v \
    -H "content-type: application/json" \
    -d '{"body": "world"}'
```

#### Chunking request

```sh
curl http://localhost:9080/stream -v \
    -H "content-type: application/json" \
    -d @sample-payloads/sample.json
```

#### Multiparts log: multiparts

```sh
curl http://localhost:9080/multipart -v \
    -H "content-type: multipart/form-data" \
    -F 'studentsJson={"students":[{"name":"Renuka"},{"name":"Menuka"}]};type=application/json' \
    -F 'helloXml="<hello>World</hello>";type=application/xml'
```

### Enovy Proxy 

```sh
curl http://localhost:8080/post\?query\=foo -v \
    -H 'Foo: Renuka' -H 'Content-Type: application/json' -H "Transfer-Encoding: chunked"\
    -d @sample-payloads/sample.json
```

#### Multiparts log: multiparts

```sh
curl http://localhost:8080/multipart -v \
    -H "content-type: multipart/form-data" \
    -F 'studentsJson={"students":[{"name":"Renuka"},{"name":"Menuka"}]};type=application/json' \
    -F 'helloXml="<hello>World</hello>";type=application/xml'
```
