package org.renuka.k8s.prometheus.app.controllers;

import io.prometheus.client.Counter;
import io.prometheus.client.Summary;
import org.renuka.k8s.prometheus.app.dto.Product;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@RestController
public class ProductController {
    // metrics: total request counter
    private static final Counter requestCount = Counter.build().name("backend_http_requests_total")
            .labelNames("http_method", "http_url", "priority").help("Products: Total http requests").register();
    private static final Summary requestLatency = Summary.build().name("backend_requests_latency_seconds")
            .labelNames("http_method", "http_url", "priority").help("Products: Request latency in seconds.").register();

    static {
        // expose metrics names
        requestCount.labels("", "", "").inc(0);
        requestLatency.labels("", "", "").observe(0D);
    }

    // products
    private static Map<Integer, Product> products = new HashMap<>();
    private static Integer lastProductId = 105;

    // load products
    static {
        products.put(101, new Product(101, "Apples", "Food", 1.49D));
        products.put(102, new Product(102, "Macaroni & Cheese", "Food", 7.69D));
        products.put(103, new Product(102, "ABC Smart TV", "Electronics", 399.99D));
        products.put(104, new Product(104, "Motor Oil", "Automobile", 22.88D));
        products.put(105, new Product(105, "Floral Sleeveless Blouse", "Clothing", 21.50D));
    }

    @GetMapping("/products")
    public ResponseEntity<Collection<Product>> getProducts(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String category,
            @RequestParam(required = false, name = "lower-than") Integer lowerThan,
            @RequestParam(required = false, name = "higher-than") Integer higherThan

    ) {
        requestCount.labels("GET", "/products", "HIGH").inc();
        Summary.Timer requestTimer = requestLatency.labels("GET", "/products", "HIGH").startTimer();

        ResponseEntity<Collection<Product>> response;
        try {
            Stream<Product> productStream = products.values().stream();
            if (name != null) {
                productStream = productStream.filter(product -> product.getName().contains(name));
            }
            if (category != null) {
                productStream = productStream.filter(product -> product.getCategory().equalsIgnoreCase(category));
            }
            if (lowerThan != null) {
                productStream = productStream.filter(product -> product.getPrice() <= lowerThan);
            }
            if (higherThan != null) {
                productStream = productStream.filter(product -> product.getPrice() >= higherThan);
            }
            response = ResponseEntity.ok(productStream.collect(Collectors.toList()));
        } finally {
            requestTimer.observeDuration();
        }

        return response;
    }

    @GetMapping("/empty-response")
    public String getEmpty() {
        return null;
    }

    @GetMapping("/entries")
    public String getSame(@RequestBody(required = false) String str) {
//        return new ResponseEntity<>(null, HttpStatus.OK);
        return str;
    }

    @GetMapping("/products/{productId}")
    public ResponseEntity<Product> getProducts(@PathVariable("productId") Integer productId) {
        requestCount.labels("GET", "/products/$id", "HIGH").inc();

        Product product = products.get(productId);
        if (product == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(product);
    }

    @GetMapping("/products/count")
    public ResponseEntity<Product.Count> getProductsCount() {
        requestCount.labels("GET", "/products/count", "LOW").inc();
        return ResponseEntity.ok(new Product.Count(products.size()));
    }

    @PostMapping("/products")
    public ResponseEntity<Product> addProduct(@RequestBody Product product) throws URISyntaxException {
        requestCount.labels("POST", "/products", "HIGH").inc();

        Integer productId = ++lastProductId;
        product.setProductId(productId);
        products.put(productId, product);
        return ResponseEntity.created(new URI("/products/" + productId)).body(product);
    }

    @PutMapping("/products/{productId}")
    public ResponseEntity<Product> updateProduct(@PathVariable("productId") Integer productId,
                                                 @RequestBody Product product) {
        requestCount.labels("PUT", "/products/$id", "LOW").inc();

        Product productOld = products.get(productId);
        if (product == null) {
            return ResponseEntity.notFound().build();
        }

        product.setProductId(productId);
        products.replace(productId, product);
        return ResponseEntity.ok(product);
    }

    @DeleteMapping("/products/{productId}")
    public ResponseEntity<Product> deleteProduct(@PathVariable("productId") Integer productId) {
        requestCount.labels("DELETE", "/products/$id", "LOW").inc();

        Product product = products.get(productId);
        if (product == null) {
            return ResponseEntity.notFound().build();
        }

        products.remove(productId);
        return ResponseEntity.ok().build();
    }
}
