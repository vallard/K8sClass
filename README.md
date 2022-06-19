# Real World Kubernetes
This is a course with practical code examples about running Kubernetes in the real world.  

This is a revamp of my somewhat popular O'Reilly class EKS in the data center.  I've taken feedback from the hundreds of people who have taken the class to make it more applicable to the real world.  

The class is available on [O'Reilly's platform](https://learning.oreilly.com/home/).  If you have a log in you can search for my name (vallard) there and watch it.  If not, feel free to use this guide and read along. 

This class is one giant demo, so you can probably follow the script easy and do this self paced. Pull requests are welcome if you see errors. 

All content was created by me, [@vallard](https://twitter.com/vallard)



## Contents

### Segment 01 - Setup & Stuff You'll Need
* [Introduction](01/README.md) Read this if you want a background on Kubernetes, Containers, and just getting started. 
* [Tools](01/tools.md) - Read this to get the tools you'll need to run these exercises. 

### Segment 02 - Ignite EKS with Terraform

* [Terraform](02/terraform.md)
* [Terragrunt](02/terragrunt.md)

### Segment 03 - Rapid Cluster Exploration

In this segment we'll go over some Kubernetes primitives.  We move fast, show what they are and what they do. 

* [Exploration](03/README.md)

### Segment 04 - Real World Use Cases

* [Load Balancers](04/ELB.md)
* [Ingress Controllers](04/Ingress.md)
* [Cert-Manager & Let's Encrypt](04/TLS.md)
* [November Rain: Persistent volumes](04/PV.md)
* [External Secrets with AWS SecretsManager](04/Secrets.md)


### Segment 05 - Boss Operations

* [Cluster Autoscaling](05/README.md)
* [Lens & K9s](05/viz.md)
* [Additional Users with Roles and RoleBindings](05/users.md)

### Segment 06 - Putting it together:  Running Your Own App 

* [Create a Python Flask Application from Scratch](06/README.md) 
* [Makefiles, Dockers and Registries](06/README.md)
* [Terraform for DynamoDB](06/README.md)
* [Ta-da!  The app! 🎉](06/README.md)
* [Service Accounts for DynamoDB access](06/README.md)





