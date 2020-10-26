# Envoy MTLS Sample

## 1. Create Certificates for Server (Listeners) and Client (curl)

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
```

## 3. Try out

Add ingress host `ingress.foo.com` to `/etc/hosts`
```
127.0.0.1    ingress.foo.com
```

### 3.1. HTTP

```sh
curl http://ingress.foo.com/products
```

### 3.2. HTTPS

Try out in a new terminal and same working directory.
```sh
curl https://ingress.foo.com/products \
    --cacert certs/server/ca.crt \
    --cert certs/client/server.crt \
    --key certs/client/server.key
```
