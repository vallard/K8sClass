# Create EKS cluster


The cost to create an EKS cluster right now is:

| Item | Cost |
|------------------|-------|
|EKS Control Plain | $0.20/hr |
|3 T3 instances | $0.1248/hr |
| NAT Gateway | $0.045/hr |
| Total | $0.37/hr |



## Get appropriate IAM permissions
You'll need the appropriate permissions on the user to create EKS clusters. The below inline policy can be created (I called it EKSFullAccess) and attached to your user. 

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        }
    ]
}
```

In addition you'll need EC2, VPC, IAM, and possibly a few others to be able to create and manage clusters. 


## Create cluster with `eksctl`

We can create our first cluster with: 

```
eksctl create cluster \
--name prod \
--version 1.14 \
--region us-west-2 \
--nodegroup-name standard-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--managed
```

(Or run [./createEKSctlCluster.sh](createEKSctlCluster.sh) )

If there are failures it is most likely related to a permission issue of your commandline user. 

You can check the cloud formation console and either roll back or add the permissions. 

This operation takes about 12-15 minutes. 
 

## Create cluster with Cloud Formation

Get [latest template](https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-11-15/amazon-eks-vpc-sample.yaml)

## Add Cluster Config to `~/.kube/config`

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


## Bonus:  Command Completer

If you use unix systems, tab completion is a big deal.  You can configure [following these instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html)


