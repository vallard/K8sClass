# Basic Application

We need to get our application ready so we can see about application alerts. 

If you haven't done the first modules in the first class, then we need to quickly get the cluster to be able to hold an application: 

```
cd 04
apply -f nginx-ingress-controller/deploy.yaml
kubectl apply -f cert-manager/cert-manager.yaml
```

Modify the DNS name to match the Load Balancer

```
kubectl apply -f cert-manager/prod-issuer.yaml
```
