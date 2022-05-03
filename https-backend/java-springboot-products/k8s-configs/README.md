# Deploy Products Service in K8s

```sh
$ kubectl apply -f .

Output:
deployment.apps/products-backend created
horizontalpodautoscaler.autoscaling/products created
service/products-backend created
```