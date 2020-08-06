# Terraform

We can use terraform to set up all of our IAM resources.  Terraform is infrastructure as code and helps us do actions quickly that otherwise are prone to human mistakes. 

## Get Terraform

The official downloads [are here](https://www.terraform.io/downloads.html).  I am on a mac and simply ran: 

```
brew install terraform
```

Test that it is installed and working: 

```
terraform version
```
Gives the output: 

```
Terraform v0.12.24
```

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

Our terraform creates a user profile including login password and access keys and secrets.  In order to use these you should create a PGP key. Once it is created you can export the base64 version of that key with: 

```
gpg export <email of key> | base64
# or
gpg --export --armor $KEYID
```
This can be put inside the [iam.tf](./iam.tf) file.

## Create IAM resources with Terraform

We can create all of these resources described above with the following commands: 

```
cd segment02-iam
terraform init 
terraform plan
terraform apply 
```

You may wish to look at the [./iam.tf](./iam.tf) file where all of these resources are defined.  It may be you need to change some of the values.  Check out the comments in this file. 

## Sign in

Get the User Password for Console Sign in 

```
terraform output password | base64 --decode  | gpg --decrypt | pbcopy
```

Make sure you installed the [aws cli tools](./aws-creds.md). Get the AWS Credentials for CLI.  On one screen type in: 

``` 
aws configure --profile=eksdude
```
Open another console and when it prompts for the access key you can get it with: 

```
terraform output key | pbcopy
```

For the secret key you can get it with: 

```
terraform output secret | base64 --decode  | gpg --decrypt | pbcopy
```

You should then verify you can actually work with this profile: 

```
export AWS_PROFILE=eksdude
aws s3 ls
aws ec2 describe-instances
aws eks list-clusters
```




## Deleting parts of the configuration

Let's say we are testing this file and we only want to delete part of what we created, in this case, let's delete `eksdude`'s access key.  We can run: 

```
terraform delete -target=aws_iam_user.eksdude