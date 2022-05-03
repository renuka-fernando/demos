# Prometheus Metrics Sample Application - Spring Boot

Docker Image: [renukafernando/k8s-prometheu-metrics-sample](https://hub.docker.com/repository/docker/renukafernando/k8s-prometheu-metrics-sample)

## 1. Test Application in Local

Create TLS certs and keystore.
```sh
# DOMAIN=ingress.foo.com
DOMAIN=localhost
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 \
    -keyout key.pem \
    -out cert.pem \
    -subj "/CN=${DOMAIN}/O=${DOMAIN}"

openssl pkcs12 -export \
    -out keystore.p12 \
    -in cert.pem \
    -inkey key.pem \
    -passout pass:admin1234
```

Set environment variables
```sh
export KEYSTORE_PATH=path/to/keystore.p12
export KEYSTORE_PASSWORD=admin1234
```

### 1.1 Run Application
Execute following to run the application
```sh
$ mvn spring-boot:run
```

### 1.2. Sample `Product` Payload
Sample payload of **Product** for methods POST and PUT methods.
```json
{
	"name": "XYZ Smart Phone",
	"category": "Electronics",
	"price": 199.99
}
```

### 1.3. Sample Requests

Following are samples for HTTP to use HTTPS invoke them as follos.
```sh
curl -X GET "https://localhost:8443/products" --cacert cert.pem
```

Sample requests for testing products service.
- Search and get products
    ```sh
    $ curl -X GET "http://localhost:8080/products"
  
    $ curl -X GET "http://localhost:8080/products?category=Electronics&lower-than=500&higher-than=300"
  
    $ curl -X GET "http://localhost:8080/products/101"
    ```
- Add product
    ```sh
    $ curl -X POST -H "Content-Type: application/json" \
        -d '{"name":"XYZ Smart Phone", "category":"Electronics", "price": "$199.99"}' \
        "http://localhost:8080/products"
    ```

- Update product
    ```sh
    $ curl -X PUT -H "Content-Type: application/json" \
        -d '{"name":"XYZ Smart Phone 20Plus", "category":"Electronics", "price": "$199.99"}' \
        "http://localhost:8080/products/106"
    ```

- Delete product
    ```sh
    $ curl -X DELETE "http://localhost:8080/products/106"
    ```

### 1.4. Get Prometheus Metrics
Get metrics by calling the resource `/metrics` after making some [sample requests](#13-sample-requests).
```sh
$ curl -X GET http://localhost:8080/metrics
```

Sample Response
```log
# HELP products_http_requests_total Products: Total http requests
# TYPE products_http_requests_total counter
products_http_requests_total{http_method="GET",http_url="/products",priority="HIGH",} 19.0
products_http_requests_total{http_method="PUT",http_url="/products/$id",priority="LOW",} 3.0
products_http_requests_total{http_method="GET",http_url="/products/$id",priority="HIGH",} 2.0
products_http_requests_total{http_method="DELETE",http_url="/products/$id",priority="LOW",} 1.0
products_http_requests_total{http_method="POST",http_url="/products",priority="HIGH",} 4.0
products_http_requests_total{http_method="",http_url="",priority="",} 0.0
# HELP products_requests_latency_seconds Products: Request latency in seconds.
# TYPE products_requests_latency_seconds summary
products_requests_latency_seconds_count{http_method="GET",http_url="/products",priority="HIGH",} 19.0
products_requests_latency_seconds_sum{http_method="GET",http_url="/products",priority="HIGH",} 0.007540193000000001
products_requests_latency_seconds_count{http_method="",http_url="",priority="",} 1.0
products_requests_latency_seconds_sum{http_method="",http_url="",priority="",} 0.0
```

### 1.5. Sample Response
Sample response of products list.
```json
[
    {
        "productId": 101,
        "name": "Apples",
        "category": "Food",
        "price": 1.49
    },
    {
        "productId": 102,
        "name": "Macaroni & Cheese",
        "category": "Food",
        "price": 7.69
    },
    {
        "productId": 102,
        "name": "ABC Smart TV",
        "category": "Electronics",
        "price": 399.99
    },
    {
        "productId": 104,
        "name": "Motor Oil",
        "category": "Automobile",
        "price": 22.88
    },
    {
        "productId": 105,
        "name": "Floral Sleeveless Blouse",
        "category": "Clothing",
        "price": 21.5
    }
]
```

## 2. Build Docker Image

Rename `IMAGE_NAME` and `VERSION` in the script `build.sh` and execute the script.
```sh
$ ./build.sh
```

## 3. Deploy in Kubernetes

Follow