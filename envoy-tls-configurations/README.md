# Sample Envoy TLS Configurations

Here are some samples for TLS configurations for envoy with following scenarios. 

1. [TLS Termination](1-tls-termination/README.md)
   
    (client) --> **HTTPS** --> (envoy proxy) --> HTTP --> (backend)
1. [TLS Origination (Re-encrypt)](2-tls-origination/README.md)

    (client) --> HTTPS --> (envoy proxy) --> **HTTPS** --> (backend)
1. [TLS Passthrough](3-tls-passthrough/README.md)

    (client) --> HTTPS --> (envoy proxy) --> HTTPS --> (backend)

1. [mTLS](4-mtls/README.md)

    (client) <--> HTTPS <--> (envoy proxy) --> HTTP --> (backend)

## References

- Envoy TLS architectural overview: https://www.envoyproxy.io/docs/envoy/v1.16.0/intro/arch_overview/security/ssl
- Common TLS configuration: https://www.envoyproxy.io/docs/envoy/v1.16.0/api-v3/extensions/transport_sockets/tls/v3/common.proto.html
- SDS for dynamic certificate configurations: https://www.envoyproxy.io/docs/envoy/v1.16.0/configuration/security/secret
- TLS transport socket extension: https://www.envoyproxy.io/docs/envoy/v1.16.0/api-v3/extensions/transport_sockets/tls/v3/tls.proto
- TCP Proxy filter: https://www.envoyproxy.io/docs/envoy/v1.16.0/api-v3/extensions/filters/network/tcp_proxy/v3/tcp_proxy.proto
- HTTP connection manager filter: https://www.envoyproxy.io/docs/envoy/v1.16.0/api-v3/extensions/filters/network/http_connection_manager/v3/http_connection_manager.proto