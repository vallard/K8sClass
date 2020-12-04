# Securing Web Services

Let's Encrypt provides free automated TLS certificates for all of our applications.  Its so easy to use now its practically a no-brainer decision to always encrypt your services. 

## Cert Manager

[Cert Manager](https://github.com/jetstack/cert-manager) is a service we can use to apply for certs and automate the renewal process.  Its fast and easy and works seemlessly on EKS.  

To install its as simple as: 

```
$ kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml
```

To see what was installed run: 

```
kubectl get pods -n cert-manager
```

The main service watches for changes in Kubernetes and then acts to create certificate requests if needed. 

You'll want to test with the staging issuer. 

```
cd cert-manager
kubectl create -f staging-issuer.yaml
```

Since we've tested before we will just do the production issuer: 

```
kubectl create -f prod-issuer.yaml
```
You can see these resources created: 

```
kubectl get clusterissuers
```

This will show: 

```
NAME                  READY   AGE
letsencrypt-prod      True    96s
letsencrypt-staging   True    108s
```

Now to create the TLS certificate on our application we just modify the ingress rule.  

Take a look at `ngx-ing.yaml` in the same directory.  You will see a few small changes: 

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    kubernetes.io/ingress.class: nginx
  name: ngx
  namespace: default
spec:
  tls:
  - hosts:
    - k8s.castlerock.ai
    secretName: ngx-tls-cert
  rules:
    - host: k8s.castlerock.ai
      http:
        paths:
        - backend:
            serviceName: ngx
            servicePort: 80
```

The changes are: 

* `cert-manager.io/cluster-issuer: letsencrypt-prod` - tells that we want to issue TLS and the cluster issuer to use to get that certificate. 
* `tls` - this specifies which domain we want as well as where to store the TLS secrets once we have obtained them from the service.  

After a few minutes, magically, the domain will be secured.  

To troubleshoot you can look at a few custom resources: 

```
kubectl get orders
kubectl get certificates
kubectl get certificaterequests
```

These are the actions created when the ingress rule specifies a TLS service.  Check your domain again and see that it works with encryption!