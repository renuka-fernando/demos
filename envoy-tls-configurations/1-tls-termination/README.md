# Envoy TLS Configurations

Try Envoy TLS configurations with docker-compose

## 1. TLS Termination

### 1.1. Create certs

```sh
./create-certs.sh
```

Test the backend server by directly invoking
```sh
curl http://localhost:8080/products
```

### 1.2. Run Envoy

```sh
docker-compose up
```

### 1.2. Try out

Add ingress host `ingress.foo.com` to `/etc/hosts`
```
192.168.8.132    ingress.foo.com
```

#### 1.2.1. HTTP

```sh
curl http://ingress.foo.com/products -v
```

#### 1.2.2. HTTPS

Try out in a new terminal and same working directory.
```sh
curl https://ingress.foo.com/products -v --cacert certs/servercert.pem
```
