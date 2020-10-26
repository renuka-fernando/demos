# Envoy TLS Termination Sample

## 1. Create Certificates for Listeners

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
curl https://ingress.foo.com/products --cacert certs/ca.crt
```
