# Default Backend

## Add Hosts

Add following entry to the `/etc/hosts/`

```
127.0.0.1   localhost-1 localhost-2 localhost-3 localhost-4 localhost-5
```

## Apply configurations

```sh
./apply.sh
```

## Test Setup

```sh
# -> service 2
curl http://localhost-2/products

# -> service 3 (if ingress 2 applied first this should be service 5)
curl http://localhost-2/prod

# -> service 1
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


## Delete configurations

```sh
./delete.sh
```