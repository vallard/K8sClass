# Other AWS tricks

## Combine Serverless with Kubernetes

We can make our serverless functions work with our Kubernetes cluster.  Why would we want to do that? 

* Have serverless functions trigger jobs
* Have serverless functions create workloads for different projects. 

As an example in our company we created a [Matomo](https://matomo.org) service. When people would sign up we would deploy a matomo instance for them.  Instead of creating VMs we would have it create several kubernetes constructs including: 

* Deployment for Database
* Deployment for Matomo
* Service for Matomo and Database
* TLS generation for ingress rules for Matomo
* Secret files for Matomo for passwords,etc. 

Let's show how we can make this happen. 

### Serverless

The [serverless.com](https://serverless.com) framework allows you to create serverless functions with AWS.

#### Build the serverless environment. 

The serverless environment is built on node.  If you don't know node then there are lots of places to learn, however this is beyond the scope of this class.    

```
cd segment07*/
npm install serverless-python-requirements
```

#### Edit the `serverless.conf` file

Here we need to put in our cluster in the environment variables. 

Test locally with: 

```
sls invoke local -f list
```

This should list all your kubernetes pods in the cluster. 


You can then deploy this with: 

```
sls deploy
```

Now we can list our Kubernetes deployments in our cluster with: 


