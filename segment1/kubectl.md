# `kubectl`

[kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) is a command line tool used to interact with Kubernetes clusters. 

We install the tool locally on your laptop or jump host where you access kuberentes.  In non-AWS clusters you can also install it on your master nodes and run there.  With EKS clusters, you don't have access to the master nodes, so you can't access there. 

The common CRUD commands we use with Kubernetes resources are: 

* `get`
* `create`
* `describe`
* `delete`

For example, you might first list your pods with: 

`kubectl get pods`

Then you may see a pod that has an error.  You can investigate why a pod has an error with: 

`kubectl describe pod <pod name>`

This might then tell you why a pod couldn't start (not enough available space on nodes, container image can't be found, or volume can't be mounted)

## Installing kubectl

[Official Instructions are found here](https://kubernetes.io/docs/tasks/tools/install-kubectl/).  

### Mac

You can use `brew` to install kubernetes or use the curl command found in the [docs](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos).

### Windows

There are a few ways with Windows [documented here.](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-windows) including:

* Download binary 
* Powershell from PSGallery
* Chocolatey or Scoop


## Testing kubectl 

```
kubectl version
```

You might get an error saying you can't connect to a server, but that's ok.  


## `kubectl` configuration

The `kubectl` configuration lives inside of `~/.kube/config` file.  This file can be created by you.  We use the eksctl tool to create this automatically for you. We'll get to that later after we've brought up our cluster. 


 