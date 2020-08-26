# Test 10 APIs in Concurrent using K8s-API-Operator in Ingress Mode

## Install API-Operator

#### Deploy Products Backend

```sh
kubectl apply -f products-targetendpoint.yaml
```

#### Deploy Security

```sh
apictl create ns wso2-demo
```

```sh
kubectl apply -f jwt-security.yaml
kubectl apply -f basic-security.yaml
```

#### Switch to Ingress Mode

Install the [Nginx-ingress controller](https://kubernetes.github.io/ingress-nginx/deploy/).

```sh
kubectl patch configmap controller-config -n wso2-system \
    -p '{"data":{"operatorMode":"ingress"}}'
kubectl patch configmap ingress-configs -n wso2-system \
    -p '{"data":{"ingressHostName":"mgw.ingress.wso2.com"}}'
```

#### Create APIs
- APIs with Default Security    : 4 - APIs [1-4]
- APIs with JWT Security        : 3 - APIs [5-7]
- APIs with Basic Auth Security : 3 - APIs [8-10]

```sh
# create APIs concurrently
for i in {1..10}
do
    apictl add api \
            -n "products-${i}-api" \
            --from-file "swagger-${i}.yaml" \
            --namespace wso2-demo \
            --override &
done
```

#### Tokens

```
DEFAULT_TOKEN=eyJ4NXQiOiJNell4TW1Ga09HWXdNV0kwWldObU5EY3hOR1l3WW1NNFpUQTNNV0kyTkRBelpHUXpOR00wWkdSbE5qSmtPREZrWkRSaU9URmtNV0ZoTXpVMlpHVmxOZyIsImtpZCI6Ik16WXhNbUZrT0dZd01XSTBaV05tTkRjeE5HWXdZbU00WlRBM01XSTJOREF6WkdRek5HTTBaR1JsTmpKa09ERmtaRFJpT1RGa01XRmhNelUyWkdWbE5nX1JTMjU2IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJhZG1pbkBjYXJib24uc3VwZXIiLCJhdWQiOiJKRmZuY0djbzRodGNYX0xkOEdIVzBBR1V1ME1hIiwibmJmIjoxNTk3MjExOTUzLCJhenAiOiJKRmZuY0djbzRodGNYX0xkOEdIVzBBR1V1ME1hIiwic2NvcGUiOiJhbV9hcHBsaWNhdGlvbl9zY29wZSBkZWZhdWx0IiwiaXNzIjoiaHR0cHM6XC9cL3dzbzJhcGltOjMyMDAxXC9vYXV0aDJcL3Rva2VuIiwiZXhwIjoxOTMwNTQ1Mjg2LCJpYXQiOjE1OTcyMTE5NTMsImp0aSI6IjMwNmI5NzAwLWYxZjctNDFkOC1hMTg2LTIwOGIxNmY4NjZiNiJ9.UIx-l_ocQmkmmP6y9hZiwd1Je4M3TH9B8cIFFNuWGHkajLTRdV3Rjrw9J_DqKcQhQUPZ4DukME41WgjDe5L6veo6Bj4dolJkrf2Xx_jHXUO_R4dRX-K39rtk5xgdz2kmAG118-A-tcjLk7uVOtaDKPWnX7VPVu1MUlk-Ssd-RomSwEdm_yKZ8z0Yc2VuhZa0efU0otMsNrk5L0qg8XFwkXXcLnImzc0nRXimmzf0ybAuf1GLJZyou3UUTHdTNVAIKZEFGMxw3elBkGcyRswzBRxm1BrIaU9Z8wzeEv4QZKrC5NpOpoNJPWx9IgmKdK2b3kIWJEFreT3qyoGSBrM49Q

JWT_TOKEN=eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJyZW51a2FAY2FyYm9uLnN1cGVyIiwiYXVkIjoicHJvZF9yZW51a2EiLCJuYmYiOjM1OTcyMTE5NTMsImlzcyI6Imh0dHBzOi8vcHJvZHVjdHMuY29tL29hdXRoMi90b2tlbiIsImV4cCI6MzkzMDU0NTI4NiwiaWF0IjoxNTk3MjExOTUzfQ.eOc0vMYdcqRF96WU_ERE8Wowc3GpbheANqMkN47-lgdHJmRxHp1-TVXVWH7S3vVWG987jQ9J_mCFGzGjfsbiV_QK5UBLKe4JvmILu-p5dc5vhcWQqCzSNORPRcvsZPJkRH8RzInRPndsSZdypxA7ixPtzp5k0pP1MoAL2yp5GoxcHX_APjEI8yAFb2Wg_DgWjGE3WaIzhzPXz5qAwOU4pjjk5TOaVTcC7gjWLTEj4c1KKjTH4rIwGj58Aa16klQEu-9EOE9otDSvOKKLlC0tANUm5Wb4gwwnaRnX50gQU0C6BvhwtvhgNje_w3Hbl8dI-hapwfd9HwwEN6xTKd18HA

BASIC=cmVudWthOmFkbWlu
```

#### Try-Out

Get <ADDRESS> of ingress
```sh
kubectl get ingress -n wso2-demo
```

Set ADDRESS values
```sh
ADDRESS=<ADDRESS>
```

##### Invoke API with Default Security
```sh
curl "https://${ADDRESS}/products_1/v1/products" \
        -X GET \
        -H "Host:mgw.ingress.wso2.com" \
        -H "Authorization:Bearer $DEFAULT_TOKEN" \
        -k
```

##### Invoke API with JWT Security
```sh
curl "https://${ADDRESS}/products_5/v1/products" \
        -X GET \
        -H "Host:mgw.ingress.wso2.com" \
        -H "Authorization:Bearer $JWT_TOKEN" \
        -k
```

##### Invoke API with Basic Auth
```sh
curl "https://${ADDRESS}/products_8/v1/products" \
        -X GET \
        -H "Host:mgw.ingress.wso2.com" \
        -H "Authorization:Basic $BASIC" \
        -k
```

#### Clean Up

```sh
kubectl delete ns micro
kubectl delete ns wso2-demo
```