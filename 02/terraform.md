# Terraform

We can use terraform to set up our entire AWS EKS infrastructure including our IAM resources and networking.  Terraform is infrastructure as code and helps us do actions quickly that otherwise are prone to human mistakes. 

Note: This was tested and created with version `1.2.1`

## Create IAM resources

When using EKS it is strongly recommended to NOT use the root AWS account.  There are errors that can show up.  As such, use another account to create EKS resources.  

We will create a user account by first making policies, adding them to a group, and then creating a user and assigning them to this group.  This way if we want to add other EKS users we simply create them and add them to the group. 

By using Terraform we can ensure that we use infrastructure as code to define these resources.  

### Policies

We will create an EKS policy that allows some one full access to EKS. 

### Group

We will create an EKSDemoGroup that will have all the necessary policies we need for the remainder of this class. 

### Users

We will create one user called `eksdude` that will be used to create the cluster resources for us. 

### PGP

Our terraform creates a user profile including login password and access keys and secrets.  In order to use these you should create a PGP key. We installed `gnupg` in the [first part](../01/tools.md).  Now we need to generate our key: 

```
gpg --gen-key
```

This walks us through a menu: 

```
gpg (GnuPG) 2.3.6; Copyright (C) 2021 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Note: Use "gpg --full-generate-key" for a full featured key generation dialog.

GnuPG needs to construct a user ID to identify your key.

Real name: Vallard Benincosa
Email address: vallard@castlerock.ai
You selected this USER-ID:
    "Vallard Benincosa <vallard@castlerock.ai>"

Change (N)ame, (E)mail, or (O)kay/(Q)uit? O
```


Once it is created you can export the base64 version of that key with: 

```
gpg --export engineering@castlerock.ai | base64 | pbcopy 
```
This can be put inside the [terraform/iam/vars.tf](../terraform/iam/vars.tf) file.

## Create IAM resources with Terraform

We can create all of these resources described above with the following commands: 

```
cd 02/terraform/iam
terraform init 
terraform plan
terraform apply 
```

You may wish to look at the [./iam.tf](./iam.tf) file where all of these resources are defined.  It may be you need to change some of the values.  Check out the comments in this file. 

## User Sign in

We created the user with our `iam.tf` and we can use the output to log in as the user.

### Console Sign in

Get the User Password for Console Sign in 

```
cd terraform/iam
export GPG_TTY=$(tty) # just to be sure. 
terraform output -raw password | base64 --decode  | gpg --decrypt | pbcopy
```

### Command line Sign in

Make sure you installed the [aws cli tools](./aws-creds.md). Get the AWS Credentials for CLI.  On one screen type in: 

``` 
aws configure --profile=eksdude
```
Open another console and when it prompts for the access key you can get it with: 

```
terraform output -raw key | pbcopy
```

For the secret key you can get it with: 


```
terraform output -raw secret | base64 --decode  | gpg --decrypt | pbcopy
```


You should then verify you can actually work with this profile: 

```
export AWS_PROFILE=eksdude
aws s3 ls
aws ec2 describe-instances
aws eks list-clusters
```




## (Optional) More with Terraform 

As the `eksdude` we can continue on in Terraform and start up the EKS cluster.  However, at this point, we should instead move over to terragrunt as there are more capabilities we get from it.  If you decide to do this portion, you may want to destroy it before moving on to Terragrunt at the end.  (e.g: make the cluster but then destroy it when done.)


### Terraform the Network

```

cd terraform/network
terraform init
terraform plan 
terraform apply
```

### Create EKS with Terraform

```
cd 02/terraform/eks
terraform init
terraform plan 
terraform apply
```

### Log into EKS Cluster

We created the EKS cluster with a role rather than a user.  Users may come and go in our system but we gave the user `eksdude` permissions to access the role that created the cluster.  

#### 1. Update `~/.kube/config`

We add the cluster login permissions to the `config` file automatically by running:  

```
aws eks update-kubeconfig --name eks-stage --alias eks-stage --role-arn arn:aws:iam::188966951897:role/eks_dude_role
```

#### 2. Add the role

The above command adds the bottom role information to the kube config file. You will see lines similar to below: 

```
      - --role-arn
      - arn:aws:iam::XXXXXX951897:role/eks_dude_role
```

To the `args:` list at the very end of the file.  (Note:  The account ID is my account ID and will need to be changed to match your account ID.)

#### 3. Login

We can now log in: 

```
kubectl get pods -n kube-system
```

This is a very basic use case of Terraform.  Let's see how to do a few more advanced moves using Terragrunt in [our next section](./terragrunt.md)

### Delete the Cluster and Network

The previous network and EKS cluster should be deleted so we don't get charged for it!  You can do this by doing the following: 

```
cd terraform/eks
terraform destroy
cd terraform/network
terraform destroy
```



# Appendix: Deleting parts of the Terraform plan

Let's say we are testing this file and we only want to delete part of what we created, in this case, let's delete `eksdude`'s access key.  We can run: 

```
terraform delete -target=aws_iam_user.eksdude
