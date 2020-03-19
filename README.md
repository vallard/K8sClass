# Kubernetes on AWS
## Using Amazon Elastic Kubernetes Service
Materials Created by me, [@vallard](https://twitter.com/vallard)

## Contents

This repo is for a class I teach on using [EKS](https://aws.amazon.com/eks/).  This class assumes you have a basic idea and understanding about: 

* Python
* AWS
* Docker
* Kubernetes - you should know at least a little about it. 

The purpose of the class is to show how to get an EKS cluster up and running, do some administration, and then run some applications.  Finally we show how to integrate other AWS services (Lambda, DynamoDB) in with our EKS cluster. 

### Segment 1 - Introduction / Foundations
* [Introduction](segment01-intro/INTRO.md)
* [Why Containers are a big deal](segment01-intro/containers.md)
* [Trade Offs](segment01-intro/tradeoffs.md)
* Clone Github Resources
* Benefits of Kubernetes on AWS
* [Install `kubectl`](segment01-intro/kubectl.md)



### Segment 2 - IAM
* Create IAM Policies
* Create IAM Group
* Create IAM Roles
* Create IAM User
* [AWS Setup](segment02-iam/aws-creds.md)
* [Install `eksctl`](segment02-iam/eksctl.md)


### Segement 3 - Launch EKS
* [Launch the EKS cluster with eksctl](segment03-install/eks.md)
* `kubectl` access

### Segment 4 - Cluster Verification
* [Verify components and launch sample test application](segment04-verify/README.md)


### Segment 5 - Running Applications
* [Loadbalancers](segement05-applications/ELB.md)
* [Ingress](segment05-applications/Ingress.md)
* [Configure R53 DNS to point to the ELB](segment05-applications/r53.md)
* [TLS certificates](segement05-applications/TLS.md)
* [Persistent Volumes](segment05-applications/PV.md)

### Segment 6 - Cluster Lifecycle
* [Cluster Autoscaling](segment06-admin/README.md)
* [Horizontal Pod Autoscaling](segment06-admin/README.md#horizontal-pod-autoscaler)
* [Kubernetes Dashboard](segment06-admin/README.md#kubernetes-dashboard)
* [Add additional users to the cluster](segment06-admin/README.md#additional-user-access)
* [Updating the cluster](segment06-admin/README.md#cluster-upgrades)

### Segment 7 - Connecting to additional AWS services
* [Serverless with EKS](segmenet07-integrations/README.md)
* [EKS DynamoDB example](segment07-integrations/dynamo-example/README.md)



