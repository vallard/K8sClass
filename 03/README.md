# 03 - Exploring Kubernetes

Now that cluster is up, you should have access to it using `kubectl` commands.  Let's take a look at our system.   

## Namespaces
Each cluster can have namespaces which logically seperate the different applications, pods, and services into logical groupings. 

```
kubectl get ns
```

## Pods

There are many pods on the cluster, even though you don't see any in your default namespace: 

```
kubectl get pods
```
Try looking at all the namespaces and you'll see some more: 

```
kubectl get po --all-namespaces
```
Here we see quite a few: 

```
kube-system   aws-node-6jjnf            1/1     Running   0          37m
kube-system   aws-node-7cdw6            1/1     Running   0          36m
kube-system   aws-node-g6tkd            1/1     Running   0          36m
kube-system   coredns-84549585c-jj6q5   1/1     Running   0          41m
kube-system   coredns-84549585c-sx2jf   1/1     Running   0          41m
kube-system   kube-proxy-76wgk          1/1     Running   0          36m
kube-system   kube-proxy-f7w2p          1/1     Running   0          37m
kube-system   kube-proxy-ppl9p          1/1     Running   0          36m
```

Let's describe what is happening here: 

### AWS Node Daemonset

A Daemonset is a kubernetes construct where a pod is to run on every node in the cluster.  In this case, it's the `aws-node` pod.  This pod contains the CNI plugins necessary for EC2 nodes to be able to communicate with the Amazon VPC CNI.  (Basically the overlay network on top of VPCs.).  We can see the version of the CNI plugin with: 

```
kubectl describe ds aws-node -n kube-system
```
On non-EKS clusters you may see things like Calico or Weave that do the overlay networking for the nodes. 

### Kube Proxy

A daemon set that allows network connectivity to happen with the pods on the node.  You can see TCP rules added when pods are created by looking at the logs of the node: 

```
kubectl logs -n kube-system kube-proxy-XXXXX
```


## Services

To see what services are running run: 

```
kubectl get svc --all-namespaces
```

### kubernetes service

The API that pods and other components in the cluster can access if they need to interact with Kubernetes.  Most pods don't need to talk to the kubernetes service but things like [custom defined resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) do. These items allow you to extend Kubernetes. 

### Kubernetes DNS

An internal DNS service that allows pods to communicate.  For example, suppose we have one pod that runs as a database and another pod that depends upon it.  Instead of having to use the IP address for the database we can call it by its service name. 

## Test some pods

Let's create 2 pods and a service: 

```
kubectl apply -f ./dnstest
```
#### Note: the old version of deployments were in extension/v1beta1 have moved to app/v1 in version 16 of Kubernetes.

To examine them run: 

```
kubectl get pods
```

You'll see output that looks something like:  

```
NAME                   READY   STATUS    RESTARTS   AGE
bb8-867cf6fb4c-dfdk7   1/1     Running   0          10m
ngx-56d6dbb9d8-5mfsb   1/1     Running   0          10m
```

There is one nginx service (the generic web page) and one busybox pod running for us to run tests on. 

We also just deployed a service for the nginx pod: 

```
kubectl get svc
```

Gives us something like: 

```
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.100.0.1      <none>        443/TCP   78m
ngx          ClusterIP   10.100.117.55   <none>        80/TCP    14m
```

Here above 👆🏼we see that the service name is `ngx`.  So our other pods can reference `ngx` and the service will direct them to the pod that is running nginx. 


Let's log into the busybox pod and test: 

```
kubectl exec -it bb8-86... -- /bin/sh  
```

To get the Nginx service we can run: 

```
wget -q -S -O - ngx
```
This will then print the output of the html generated from the page.  Our CoreDNS does in fact work!

You could also reference it by longer names if it were in a different namespace: 

```
wget -q -S -O - ngx.default
wget -q -S -O - ngx.default.svc
```

Here we use the namespace (default) to reference.  



