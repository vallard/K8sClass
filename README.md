# Kubernetes on AWS
## Using Amazon Elastic Kubernetes Service
Materials Created by me, [@vallard](https://twitter.com/vallard)

### ⚠️ THIS IS A WORK IN PROGRESS AND WILL BE COMPLETE BY FEB 25, 2020. ⚠️

✅ Most of the materials are not yet uploaded but will be soon!


## Contents

### Segment 1 - Introduction / Foundations
* Introduction
* Big Picture Overview
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
* lambda functions to run something on EKS cluster
* Jobs on EKS access DynamoDB and S3



