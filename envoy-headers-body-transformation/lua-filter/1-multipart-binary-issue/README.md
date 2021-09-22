## Lua filter reading multipart/form-data with bytes

### 1. Run Setup

```sh
bal run --offline backend-service.bal
```

```sh
docker compose up
```

```sh
curl http://localhost:8080/multipart -v \
    -H "content-type: multipart/form-data" \
    -F 'studentsJson={"students":[{"name":"Renuka"},{"name":"Menuka"}]};type=application/json' \
    -F 'helloXml="<hello>World</hello>";type=application/xml' \
    -F profile=@refrigerator-clipart.png
```


### 2. Results

#### 2.1. Envoy
```log
envoy_1  | [2021-09-22 09:06:31.856][16][info][lua] [source/extensions/filters/http/lua/lua_filter.cc:795] script log: Global Lua: Hello
envoy_1  | [2021-09-22 09:06:31.856][16][info][lua] [source/extensions/filters/http/lua/lua_filter.cc:795] script log: content length from header: 70587
envoy_1  | [2021-09-22 09:06:31.870][16][info][lua] [source/extensions/filters/http/lua/lua_filter.cc:795] script log: content length from body length: 70587
envoy_1  | [2021-09-22 09:06:31.870][16][info][lua] [source/extensions/filters/http/lua/lua_filter.cc:795] script log: BODY
envoy_1  | [2021-09-22 09:06:31.870][16][info][lua] [source/extensions/filters/http/lua/lua_filter.cc:795] script log: --------------------------c69f425148ecc5ef
envoy_1  | Content-Disposition: form-data; name="studentsJson"
envoy_1  | Content-Type: application/json
envoy_1  |
envoy_1  | {"students":[{"name":"Renuka"},{"name":"Menuka"}]}
envoy_1  | --------------------------c69f425148ecc5ef
envoy_1  | Content-Disposition: form-data; name="helloXml"
envoy_1  | Content-Type: application/xml
envoy_1  |
envoy_1  | <hello>World</hello>
envoy_1  | --------------------------c69f425148ecc5ef
envoy_1  | Content-Disposition: form-data; name="profile"; filename="refrigerator-clipart.png"
envoy_1  | Content-Type: image/png
envoy_1  |
envoy_1  | �PNG
envoy_1  |
envoy_1  |
envoy_1  | [2021-09-22 09:06:31.870][16][info][lua] [source/extensions/filters/http/lua/lua_filter.cc:795] script log: content length from response body length: 495
envoy_1  | [2021-09-22 09:06:31.870][16][info][lua] [source/extensions/filters/http/lua/lua_filter.cc:795] script log: DONE
envoy_1  | [2021-09-22 09:06:32.168][16][info][lua] [source/extensions/filters/http/lua/lua_filter.cc:795] script log: Global Lua: Bye
```

#### 2.2. Backend

```log
time = 2021-09-22T14:36:32.111+05:30 level = ERROR module = "" message = "Error occurred while retrieving body parts from the request"
```
