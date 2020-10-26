# Envoy TLS Sample with Combining All

## 1. Create Certificates

```sh
./create-certs.sh
```

## 2. Run Envoy

```sh
docker-compose up
```

Test the backend server by directly invoking it.
```sh
curl http://localhost:8080/products
curl https://passthrough.ingress.com:8443/products --cacert certs/origination/products-https/ca.crt
```

## 3. Try out

Add following entries to `/etc/hosts` file.
```
127.0.0.1    tls.ingress.com
127.0.0.1    origination.ingress.com
127.0.0.1    passthrough.ingress.com
127.0.0.1    mtls.ingress.com
```

### 3.1. HTTP No TLS

```sh
curl http://tls.ingress.com/products
```

### 3.2. HTTPS

#### TLS termination
```sh
curl https://tls.ingress.com/products --cacert certs/tls/ca.crt
```

#### TLS Origination
```sh
curl https://origination.ingress.com/products --cacert certs/origination/ca.crt
```

#### TLS Passthrough
Backend server configured with origination configs so using certs in origination
```sh
curl https://passthrough.ingress.com/products --cacert certs/origination/products-https/ca.crt
```

#### mTLS
 ```sh
curl https://mtls.ingress.com/products \
    --cacert certs/mtls/server/ca.crt \
    --cert certs/mtls/client/server.crt \
    --key certs/mtls/client/server.key
```