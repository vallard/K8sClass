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


## External Secrets

We will also need external secrets to store our passwords for our application. 

This includes database permissions, slack APIs, etc.  The cost to store this in AWS Secrets manager is $0.40/month.  


```
helm repo add external-secrets https://charts.external-secrets.io

helm install external-secrets \
   external-secrets/external-secrets \
    -n kube-system \
    --create-namespace \
    --set installCRDs=true
```
