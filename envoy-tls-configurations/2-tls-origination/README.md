# Envoy TLS Origination (Re-encrypt) Sample

## 1. Create Certificates for Listeners and Clusters

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
curl https://localhost:8443/products --cacert certs/products-https/clientcert.pem
```

### 3.1. HTTP

```sh
curl http://ingress.foo.com/products
```

### 3.2. HTTPS

Try out in a new terminal and same working directory.
```sh
curl https://ingress.foo.com/products --cacert certs/servercert.pem
```
