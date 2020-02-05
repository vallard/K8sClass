# Kubernetes on AWS
## Using Amazon Elastic Kubernetes Service
Materials Created by me, [@vallard](https://twitter.com/vallard)

### ⚠️ THIS IS A WORK IN PROGRESS AND WILL BE COMPLETE BY FEB 25, 2020. ⚠️

✅ Most of the materials are not yet uploaded but will be soon!


## Contents

### Segment 1 - Introduction
* Introduction
* Big Picture Overview
* Clone Github Resources
* [Install `kubectl`](segment1/kubectl.md)
* [Install `eksctl`](segment1/eksctl.md)
* [AWS Setup](segment1/aws-creds.md)

### Segment 2 - Foundational Concepts
* Benefits of Kubernetes on AWS
* Compare and contrast EKS with other options
* Building blocks of EKS
* EKS Console
* Examine CloudFormation templates
* `eksctl`

### Segement 3 - Launch EKS
* [Launch the EKS cluster with eksctl](segment3/eks.md)
* Validate security groups
* Apply `ConfigMaps` to join nodes to the cluster
* `kubectl` access
* sample application to ensure cluster is running

### Segment 4 - Launch Applications
* Create application that uses Amazon EBS for persistence. 
* Create an Network Loadbalancer for accessing the cluster
* Configure R53 DNS to point to the ELB
* Install NGINX ingress controller for TLS certificates
* Access applications secure via https://

### Segment 5 - Cluster Lifecycle
* Demonstrate adding additional users to login to cluster
* Cluster Autoscaling
* Upgrading cluster

### Segment 6 - Connecting to additional AWS services
* lambda functions to run something on EKS cluster
* Jobs on EKS access DynamoDB and S3

### Segment 7 - Wrap up and Questions
* Additional feedback, etc. 

