# Load Balancers

Up until now we can only access our application via `curl` commands from inside the cluster. 

What we'd like to be able to do is access our webpage from outside the cluster. 

There are two main ways we normally do this in Kubernetes: 

* `Load Balancers`
* `Node Ports`

Before we get into those we should probably first talk about `Cluster Ports`

## Cluster IPs

   
When you run `kubectl get svc --all-namespaces` you will see the `CLUSTER-IP` of each service.  This is the default IP address assigned to the service and is used by the Service Proxies to reference the service.  Basically, `kube-proxy` creates a virtual IP address in its ip tables (assuming you are using the default IP tables) and when that address is called will direct it to the endpoint of the pod. [See here for more information](https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies)

Cluster Ports are used by the internal CoreDNS to reference services.  

## Node Ports 

Type `NodePort` will create an IP address from a range of IPs and each node will proxy that port (same port number on every Node) into your service.  So if you specify a `NodePort` of `30007` then this port will be opened on every node in the cluster.  If anyone connects to this port on any node of the cluster they will be directed to the service it refers to. 

We create NodePorts on bare metal clusters where perhaps a load balancing solution isn't baked in.  

## LoadBalancer

A service with `type: LoadBalancer` is what we use on AWS. By specifying this, Kubernetes talks to its cloud controller to speak with AWS to provision a load balancer to access the service.  This way we can talk directly to the application from the cloud.  

## Changing our service

Running `kubectl edit svc ngx` we can change the: 
`type: ClusterIP` to `type: LoadBalancer

We will then get an external load balancer that we can access our nginx server from: 

```
kubectl get svc
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)        AGE
kubernetes   ClusterIP      10.100.0.1      <none>                                                                   443/TCP        101m
ngx          LoadBalancer   10.100.45.250   a283c67cd00a149d4b4107b975006c6b-474673466.us-west-2.elb.amazonaws.com   80:30622/TCP   29m
```

Accessing this page gives us our server: 

![nginx ](./images/01.png)

## Load Balancer Types

The previous method will deploy a type of [Classic Load Balancer](https://aws.amazon.com/elasticloadbalancing/?nc=sn&loc=1) with a price of $0.025 per hour and $0.008 per GB of data processed.  

Pods running on Fargate do not support Classic nor Network Load Balancers. [1](https://docs.aws.amazon.com/eks/latest/userguide/load-balancing.html)

NLB is a little cheaper ($0.0225 vs $0.025) per hour and data of $0.006 vs $0.008. 

To change to an NLB we can simply add the annotation to our service: 

```
metadata:
	annotations:
		...
		service.beta.kubernetes.io/aws-load-balancer-type: nlb
	...
...
```

This will tell the cloud controller to create a new type of network load balancer. 

