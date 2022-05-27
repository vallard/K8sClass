# Kubernetes in a Nutshell

From the [kubernetes home page](https://kubernetes.io/):

"Kubernetes is an open-source system for automating deployment, scaling, and managmeent of containerized applications."

Kubernetes solves the problems [we spoke about in managing docker containers](containers.md). 

Ok, so what is it? Well, its clustering software. There are processes that run on controller machines and software that run on worker nodes.  However, you can also run kubernetes on just one node and run all the processes there.  But that's just for testing.  Really you'll have several worker nodes that run the software and at least one "controller" node. 

Take a look at the below picture which is found on the [Kubernetes website](https://kubernetes.io/docs/concepts/overview/components/): 

![kubernetes architecture](https://d33wubrfki0l68.cloudfront.net/7016517375d10c702489167e704dcb99e570df85/7bb53/images/docs/components-of-kubernetes.png)

The Control Plane components are all those components that run on the master node(s), or controller machines.  That is the vertical rectangle.  

In EKS, this is the portion you don't have to worry about.  You do nothing other than pay the $0.10/hr for this to run.  

The horizontal rectangle is what is run on each of the nodes.  In the case of EKS, these processes are run on each of the EC2 instances. 

## Control Plane Processes

If you want to know more about the ends and outs of the control plane services, look at [this page](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components) as this is the official Kubernetes docs.  A brief summary here: 

* `etcd`: Kubernetes is stateless. All state is stored in etcd. 
* `kube-apiserver`: process responsible for receiving input from `kubectl` and processes running in Kubernetes. 
* `kube-scheduler`: The bin packer.  Where to place containers that need to get scheduled? 
* `kube-controller-manager`: All controller processes run here.  If a pod goes down, it notices and restarts it. 
* `cloud-controller-manager`: for AWS the `kube-controller-manager` dishes commands from its controllers out to the cloud-controller-manager to create resources on its behalf to the cloud.  This includes interacting with AWS to create Load Balancers, Volumes, and networking routing for the pods. 

## Node Components

* `kubelet` The Kubelet agent runs on every node and is responsible for talking to docker and bringing up containers as directed by the scheduler.  
* `Kube-proxy` is used for creating IP tables rules so when nodes or other containers attempt to communicate with containers running on this node, IP Table rules forward traffic to the container.
* `Docker` while other container runtimes are possible, we mostly see docker running on these worker nodes.  

## Kubernetes Constructs
Now that we've seen what makes up the basic skeleton of the kubernetes cluster lets talk briefly about the key components that make Kubernetes special. 

### Pods
The pod is the atomic unit of management for kubernetes containers.  Sometimes we'll use the term "pod" interchangably with "container".  That is because most of the time in practice you'll only have one container in a pod.  However, a Pod denotes a runtime namespace for an application that sometimes similarly grouped containers will run in this one atomic unit.  Containers that run in a pod share the same IP address and access to storage volumes. 

The one reason this construct exists in the first time, rather than just managing a container is because the idea that the Borg paper laid out of having helper containers run that do health checks to the application running in the main container. 

By packaging in a container that can constantly give you the status of the application you can know when processes are down or not functioning correctly. 

The other reason this construct helps is the ability to do tricky networking proxying like that done by [Envoy](https://www.envoyproxy.io/)

### Deployments

A deployment is a declarative way of saying: "I want X amount of Pod Ys running".  If something happens to one of those pods, then the declaration lets the kube-controller know that things are not as they ought to be and it fixes it by creating a new one. Deployments declare you're intent. Often when creating a pod, we use a deployments to create them. 

All Kubernetes constructs can be given to the API server as YAML files. This is how we normally do things in Kubernetes.  

For example, here is a brief deployment example that you'll see we use in this class: 

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    run: ngx
  name: ngx
spec:
  replicas: 1
  selector:
    matchLabels:
      run: ngx
  template:
    metadata:
      labels:
        run: ngx
    spec:
      containers:
      - image: nginx
        name: ngx
```

Here we give it some metadata name, like the label of this deployment which is used by other Kubernetes constructs to refer to this deployment. We also define the spec of the container.  The docker image it gets is `nginx` and we call it all `ngx`. 

### Services

Services create a virtual static IP address (VIP) that allows us to refer to underlying pods that may always be changing.  For example, suppose we have 5 web servers running in our deployment. (change the `replicas` count to 5 in the above example.)  We would create a service, via a `yaml` file that would refer to these pods.  If a pod crashes or changes, or if more pods are added, the VIP stays the same, is loaded in KubeDNS and thus we can always refer to it as long as some pod exists on the backend that we can attach to. 

Here is a `yaml` example we will use later: 

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    run: ngx
  name: ngx
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    run: ngx
```

Notice we refer to the port that the service is called from the outside as port `80`.  The `targetPort` is the port in the container we wish to hit.  This can be different and change.  For example, if you created a [Flask app](https://palletsprojects.com/p/flask/) and port `5000` was the default, you would set the `targetPort` to `5000` but call it externally by `port` `80`.

Services come in different types: 

* NodePort - IP is accessible by querying each individual node and then routed to an appropriate pod. 
* ClusterIP - IP is only accessible internal to the cluster. 
* LoadBalancer - IP is created by an external load balancer (NLB) and thus accessible outside the cluster.

We go into this later in more detail. 

### Ingress Controllers
The last point I'll briefly mention that makes kubernetes great is the ability to multiplex services.  Ingress Controllers are like services that you can fan out into different services by giving ingress rules.  We'll show this later.  When I first learned this, I didn't know I needed an ingress controller until I actually needed one.  Once you see why it makes a lot of sense.  We'll see this in [segment 5](../segment05-applications/Ingress.md).

