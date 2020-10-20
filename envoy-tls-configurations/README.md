# Envoy TLS Configurations

Try Envoy TLS configurations with docker-compose

## 1. TLS Termination

## 1.1. Create certs

```sh
./create-certs.sh
```

## 1.2. Run Envoy

```sh
docker-compose up
```

## 1.2. Try out

Add ingress host `ingress.foo.com` to `/etc/hosts`
```
192.168.8.132    ingress.foo.com
```

### HTTP

```sh
curl http://ingress.foo.com/products -v
```

### HTTPS

Try out in a new terminal and same working directory.
```sh
curl http://ingress.foo.com/products -v
```
