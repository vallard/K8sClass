# Persistence

Microservices are all about stateless systems.  Even kubernetes itself services such as the API service, the controller and scheduler all run stateless, getting their data from [etcd](https://etcd.io)

We can launch deployments and then go change the running containers but when they restart, all changes are lost. 

This was the original design of kubernetes and microservices:  Applications should be stateless and state should be a service that lives elsewhere.  We've come a long way since then and Kubernetes has evolved to give us persistence.  

## Updating Nginx

Let's change our existing nginx deployment: 

```
kubectl cp webpage/index.html ngx-5f858c479c-hgmqp:/usr/share/nginx/html/
```
This copies something to our server.  Take a look at the application now at [https://k8s.castlerock.ai](https://k8s.castlerock.ai). Now we no longer have that generic NGINX welcome screen. 

Cool, now let's kill the pod:

```
kubectl delete pod ngx-5...
```

Kubernetes will restart another pod and when it comes up the changes we made are gone. 

To make this persistent we need to add some volumes!

## Storage Class

By default EKS is installed with the gp2 storage class.  

```
kubectl get sc
```

Shows us: 

```
NAME            PROVISIONER             AGE
gp2 (default)   kubernetes.io/aws-ebs   117m
```
There are other storage classes we could make too if we needed faster speed or needed many servers to read and write from the same filesystem. We could install different storage classes [including drivers for EFS, EBS, and even Lustre](https://docs.aws.amazon.com/eks/latest/userguide/storage.html).

To take advantage of this storage class, we can create a persistent volume claim. 

## Persistent Volume Claims

We can request storage to be provisioned for us automatically with the persistent volume claim.  This is a yaml file that looks as follows: 

```
kind: PersistentVolumeClaim
metadata:
  name: ngx-pv-claim
  labels:
    app: ngx
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: gp2
```

Notice we reference the gp2 storage class as well as request the storage of 5GB (we don't need much!)

Different storage classes give us different abilities and come with different options we can use when defining the claims. 

## Persistent Volumes in Our Deployments

We can reference this claim in our pod definition.  The ngx example we've created thus far can be updated with the following: 

```diff
spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: ngx
  +      volumeMounts:
  +       - name: vol
  +         mountPath: /usr/share/nginx/html/
  +   volumes:
  +     - name: vol
  +       persistentVolumeClaim:
  +         claimName: ngx-pv-claim
```
Now we can update our pod to make it persistent: 

```
kubectl apply -f ngx-volumes.yaml
```

Since this is a new pod and new volume, we need to add the `index.html` file to the pod again otherwise it's a blank directory!  Navigating before adding will give you another NGINX error (this time coming from the pod, not the Ingress Controller) that says `403 Forbidden`.  Let's fix it!

```
kubectl cp webpage/index.html ngx...:/usr/share/nginx/html/
```

destroying the pod and waiting for it to come back up will now show that the file persists!
