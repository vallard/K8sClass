# Create EKS cluster


The cost to create an EKS cluster (`us-west-2`)

| Item             | Cost Dec 2019 | Cost Feb 2020 | Cost Aug 2020 |
|------------------|---------------|---------------|------------------|
|EKS Control Plane | $0.20/hr | $0.10/hr | $0.10/hr |
| Fargate  | | | $0.04048 vcpu + $0.004445 GB/hr |
|3 T3 instances | $0.1248/hr | $0.1248/hr |
| NAT Gateway | $0.045/hr | $0.045/hr |
| Total | $0.37/hr | $0.27/hr | 


[AWS Source](https://aws.amazon.com/eks/pricing/)



## Get appropriate IAM permissions
Your user should have the appropriate [IAM permissions](https://aws.amazon.com/iam) as discussed in the [previous section](../segment02-iam/terraform.md).

## Create cluster with `eksctl`

We can create our first cluster with [./createEKSctlCluster.sh](createEKSctlCluster.sh) 

If there are failures it is most likely related to a permission issue of your commandline user. 

You can check the cloud formation console and either roll back or add the permissions. 

This operation takes about 12-15 minutes if you don't enable Fargate or 21 minutes if you enable Fargate. 
 

## EKS Manually

We can also create an EKS cluster without using `eksctl`.  While this isn't quite manual since we use some automation, we use this to setup the prerequisites then walk through using the AWS console. 

### Service Role
You need to create an EKS Service role.  We did this in our terraform script with: 

```
########################################################
# Create EKS Service Role for Manual Kubernetes Clusters
########################################################

resource "aws_iam_role" "EKSServiceRole" {
  name = "EKSServiceRole"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "eks.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}

resource "aws_iam_role_policy_attachment" "EKSServiceRoleAttachmentsCluster" {
  role = aws_iam_role.EKSServiceRole.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "EKSServiceRoleAttachmentsService" {
  role = aws_iam_role.EKSServiceRole.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}
```

### Create the Cluster VPC

Get [latest template](https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-11-15/amazon-eks-vpc-sample.yaml).  We are going to apply this template in CloudFormation to create the subnets, routers, and network we need for our Kubernetes cluster.  If you wanted your kubernetes cluster to be in a VPC that you currently have then you could modify this or not use it at all. 


## kubectl Access 

If you use `eksctl` the cluster automatically gets added to your `~/.kube/config`.  However, if you create one via the console, you need to do a few other steps to get access. 


### Add Cluster Config to `~/.kube/config`

See which clusters are available using one of the commands below: 

```
aws eks list-clusters
eksctl get clusters
```

Update your `~/.kube/config` file with your clusters

```
aws eks update-kubeconfig --name <cluster_name>
```

e.g.:

```
$ aws eks update-kubeconfig --name eksctl-2-13
Added new context arn:aws:eks:us-west-2:188966951897:cluster/eksctl-2-13 to /Users/vallard/.kube/config
```

## Switch Between clusters

If you already had a cluster then you can still access it.  

```
kubectl config get-contexts
```




You'll see the different contexts.  You can switch between contexts with: 

```
kubectl config use-context <context name>
```

If you are switching with AWS you'll also have to change your IAM back. 

```
export AWS_PROFILE=default
```





