## Lua filter reading multipart/form-data with bytes

### 1. Run Setup

```sh
bal run --offline mediation-service.bal
```

```sh
bal run --offline backend-service.bal
```

```sh
docker compose up
```

```sh
curl http://localhost:8080/transform -v \
    -H "content-type: application/json" \
    -d '{"student":{"name":"renuka","city":"Bandaragama", "age": 27}}'
```
