# Virtual Hosts

## 1. Create Certificates for Listeners

```sh
export DOMAIN=*.ingress.com
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

Add ingress host `foo.ingress.com` and  to `/etc/hosts`
```
127.0.0.1    foo.ingress.com    bar.ingress.com
```

### 3.1. HTTP

```sh
curl http://foo.ingress.com/products
curl http://bar.ingress.com/products
```

### 3.2. HTTPS

Try out in a new terminal and same working directory.
```sh
curl https://foo.ingress.com/products --cacert certs/ca.crt
curl https://bar.ingress.com/products --cacert certs/ca.crt
```

## 4. Virtual Host

### 4.1. Add a VHost

- Down the servers docker-compose
- Replace Vhost of listener from `"*` to `"foo.ingress.com"` virtual_hosts` in envoy.yaml file

```yaml
listeners:
  - name: http_listener
    address:
      socket_address: { address: 0.0.0.0, port_value: 9080 }
    filter_chains:
      - filters:
          - name: envoy.filters.network.http_connection_manager
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
              stat_prefix: ingress_http
              codec_type: AUTO
              route_config:
                name: local_route
                virtual_hosts:
                  - name: local_service
                    domains: ["foo.ingress.com"]
                    routes:
                      - match: { prefix: "/" }
                        route: { cluster: products_http_service }
              http_filters:
                - name: envoy.filters.http.router

```

Now only the requests with the host name `foo.ingress.com` should get a valid response.

### 4.1. HTTP

```sh
curl http://foo.ingress.com/products
curl http://bar.ingress.com/products
```

### 4.2. HTTPS

Try out in a new terminal and same working directory.
```sh
curl https://foo.ingress.com/products --cacert certs/ca.crt
curl https://bar.ingress.com/products --cacert certs/ca.crt
```