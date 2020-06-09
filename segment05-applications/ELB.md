# Load Balancers

Up until now we can only access our application via `curl` commands from inside the cluster. 

What we'd like to be able to do is access our webpage from outside the cluster. 

There are two main ways we normally do this in Kubernetes: 

* `Load Balancers`
* `Node Ports`

Before we get into those we should probably first talk about `Cluster Ports`

## Cluster Ports

   
