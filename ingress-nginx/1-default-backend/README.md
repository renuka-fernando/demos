# Default Backend

## Add Hosts

Add following entry to the `/etc/hosts/`

```
127.0.0.1   localhost-1 localhost-2 localhost-3 localhost-4 localhost-5
```

## Apply configurations

Creates 2 ingresses and 5 backends with services

```sh
./apply.sh
```

## Test Setup

```sh
# -> service 2
curl http://localhost-2/products

# -> service 4 (if ingress 2 is not applied this should be service 3 which is the default backend of ingress 1)
curl http://localhost-2/prod

# -> 404 Not Found (default backend is only applied to an host)
curl http://localhost-1/prod

# -> service 2
curl http://localhost-2/products/utils

# -> service 4
curl http://localhost-2/products/tv

# -> service 4
curl http://localhost-2/products/tv/bar

# -> 503 Service Temporarily Unavailable
curl http://localhost-2/products/tv/foo

# -> 503 Service Temporarily Unavailable  (if ingress 2 applied first this should be service 1)
curl http://localhost-2/products/not
```

Delete the first rule of ingress `products-2` and apply it to the cluster.

```sh
# -> service 3 (previously it was service 4)
curl http://localhost-2/prod
```

## Delete configurations

```sh
./delete.sh
```