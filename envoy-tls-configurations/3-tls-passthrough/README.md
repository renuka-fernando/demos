# Envoy TLS Passthrough Sample

## 1. Create Certificates for Backend Service

```sh
./create-certs.sh
```

## 2. Run Envoy

```sh
docker-compose up
```

## 3. Try out

Add ingress host `ingress.foo.com` to `/etc/hosts`
```
192.168.8.132    ingress.foo.com
```

Test the backend server by directly invoking it.
```sh
curl https://ingress.foo.com:8443/products --cacert certs/products-https/ca.crt
```

### 3.1. HTTPS

Try out in a new terminal and same working directory.
```sh
curl https://ingress.foo.com/products --cacert certs/products-https/ca.crt
```
