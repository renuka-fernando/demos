# Envoy HTTP Operation level support

## 1. Run Envoy

```sh
docker-compose up
```

## 2. Try out

```sh
http://localhost:9080/hello/123 -X GET -d "hello"

Hello World - GET DIRECT
```

```sh
http://localhost:9080/hello/123 -X PUT -d "hello"

{
  "args": {}, 
  "data": "", 
  "files": {}, 
  "form": {
    "hello": ""
  }, 
  "headers": {
    "Accept": "*/*", 
    "Content-Length": "5", 
    "Content-Type": "application/x-www-form-urlencoded", 
    "Host": "localhost", 
    "User-Agent": "curl/7.77.0", 
    "X-Amzn-Trace-Id": "Root=1-6237e3f7-0e9a01556ad62fdb05db3171", 
    "X-Envoy-Expected-Rq-Timeout-Ms": "15000", 
    "X-Envoy-Original-Path": "/hello/123"
  }, 
  "json": null, 
  "method": "PUT", 
  "origin": "112.134.155.71", 
  "url": "http://localhost/anything/hello-put/put/"
}
```

```sh
http://localhost:9080/hello/123 -X POST -d "hello"

{
  "args": {}, 
  "data": "", 
  "files": {}, 
  "form": {
    "hello": ""
  }, 
  "headers": {
    "Accept": "*/*", 
    "Content-Length": "5", 
    "Content-Type": "application/x-www-form-urlencoded", 
    "Host": "localhost", 
    "User-Agent": "curl/7.77.0", 
    "X-Amzn-Trace-Id": "Root=1-6237e407-0babcc2e179c63ef19e778ad", 
    "X-Envoy-Expected-Rq-Timeout-Ms": "15000", 
    "X-Envoy-Original-Path": "/hello/123"
  }, 
  "json": null, 
  "method": "POST", 
  "origin": "112.134.155.71", 
  "url": "http://localhost/anything/hello-world/post/"
}
```
