# Trade Offs

There are many permutations of how you can run Kubernetes.  Even if you chose upstream vanilla roll-your-own kubernetes you still have choices: What network overlay will you use? Will you put it on bare metal? VMware? Public cloud?  If its a public cloud, which public cloud? 

There is no wrong answer as every decision is an exercise in evaluating trade offs. Anyone who tells you there is only one right way is probably a [Sith Lord](https://starwars.fandom.com/wiki/Sith_Lord) and will kill you when they get the chance, or they are trying to sell you something.  Ignore their advice and make your own decisions.

Let's evaluate a few tradeoffs. 

## Cloud vs. OnPrem

Even in this choice there are many options. Let's just look at the top level

### Cost

Cloud has more baked in costs associated with the hardware running 100% of the time. 
OnPrem usually requires expertise and people start eating your costs. 

If you have expertise and a data center, running on prem may save you money.  However, you will most likely experience longer delays and downtimes. 

Running on the cloud while generating a larger operating cost every month can save you on people costs and the costs of downtime. 

### Performance

Running on the cloud can scale to what appears to be infinite resources.  If you run into performance issues scaling vertically and horizontally are all options that can be done quickly and easily. 

However, you are limited to the resources the cloud provides you. If you want special hardware with crazy TPUs or GPUs you don't have as many options if you were to do this onPrem.  OnPrem might make more sense for a very specialized workload where the machines are static and special. 

OnPrem also makes more sense for a bound application where resource requirements are known.  If you are not experiencing growth with the application but know what it will be providing (some crazy [ERP system on Kubernetes? Yes, of course!](https://community.pega.com/knowledgebase/articles/client-managed-cloud/how-pega-platform-and-applications-are-deployed-kubernetes))

### Complexity 

The cloud comes fully managed if you use their services (like EKS!).  It also includes many components you'd have to add for yourself if you do onPrem.  These include: Load balancer, Storage, and overlay network.  Cloud clearly wins in this category, especially if you just want to run workloads!

### OnPrem vs Cloud Summary

When does OnPrem make more sense?

* Initial proof of concept
* When you have cheap labor (students, etc)
* When you already have sunk costs of a data center and hardware. 
* QA / Dev environments
* Specialized hardware requirements
* Non growing system

When does Cloud make more sense? 

* Teams with little operating resources (no SRE, no desire to invest in those skills)
* Proof of concepts
* Company with no data center, starting up with little resources
* Limited expertise
* Limited time

## Cloud Vendors Compared

There are plenty of great blogs on this.  Here are some resources: 

* [logz.io](https://logz.io/blog/kubernetes-as-a-service-gke-aks-eks/)
* [StackRox](https://www.stackrox.com/post/2020/02/eks-vs-gke-vs-aks/)
* [Platform 9](https://platform9.com/blog/kubernetes-cloud-services-comparing-gke-eks-and-aks/)

Generally, because Google created Kubernetes they are a bit closer to the project and updates, patches, releases, and availability are better.  GKE also has Anthos which helps for hybrid cloud solutions. 

EKS and AKS are good choices for customers already in those ecosystems who also want a kubernetes environment.  For example, if you are a serverless user on AWS with API Gateway and Lambda, having a Kubernetes cluster on EKS is a great way to integrate these services. 

From my perspective, the reason I would chose EKS is because I already have a large amount of infrastructure already on AWS and I'm not looking to expand.  

Hybrid cloud would be a better reason to chose Google as AWS still seems to view hybrid cloud as a nuisence.  (Yes, I know about [outpost](https://aws.amazon.com/outposts/).)

## EKS vs RYO AWS

Suppose you decide you want to run on AWS but you are not sure if you want to roll your own (just run on EC2 instances) or use EKS.  How do you evaluate the tradeoffs? 

### Cost

|Component| EKS ($/hr) | Roll Your Own ($/hr) |
|---|---|---|
| EKS Control Plane | $0.10  | 0 |
| 1xT3 large control node | $0 | $0.0832|
| 3xT3 large | $0.0832 x 3 | $0.0832 x 3|

This quick calculation shows on demand instances but the key difference is that the roll your own only has one node, but the EKS control plane has built in redundancy. 

This makes the costs pretty similar.  For a POC, if time if your enemy, I'd just go with EKS. 

Only last year (2019) did the control plane actually cost double the $0.10/hr at $0.20/hr.  

### Flexibility

With RYO you can use any version you want.  EKS will only support a few versions of Kubernetes: 1.12, 1.13, 1.14 (as of March 2020)

RYO you can run any type you want, any overlay, any vendor on top. 

### Complexity

EKS wins this hands down.  Less work, more applications running and delivering value.  

### RYO vs EKS summary

Unless you need to run new or unsupported versions of Kubernetes, running EKS makes a lot more sense.  It's hard to justify RYO as the cost savings just isn't there anymore. 

## EKS vs Other AWS Services

[ECS](https://aws.amazon.com/ecs/) has some advantages of being able to tie into other AWS services.  It was released as a competitor to Kubernetes and perhaps AWS begrudgingly offered EKS because of customer demand.  It too runs with Fargate.  

If you are looking for a hybrid cloud offering, ECS is probably not the way to go.  If you are all in on AWS and want faster integration to their services, go for it.  The nice thing about Kubernetes is that the skills transfer to many other clouds.  With ECS, you are banking on AWS all the way. 

[Fargate](https://aws.amazon.com/fargate/) is a serverless compute engine for containers.  It works with EKS (so you don't have to provision EC2 instances) and ECS.  It can perhaps be cheaper.  It's not available yet in all regions, but a cool service that deserves a look at!

## EKS vs Anything else

* No control plane to manage, easy to get up and running. 
* Built in Load Balancing, Networking, Volume Storage
* Easy to turn off and on

The number one reason to chose EKS over its competitors is the tie in with other AWS services: Dynamo DB, Redshift, S3, etc. If you already have your infrastructure on AWS, and your apps that will run on EKS need access to those resources, EKS is a great option. 



