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

## Create IAM resources with Terraform

We can create all of these resources described above with the following commands: 

```
cd segment02-iam
terraform init 
terraform plan
terraform apply 
```

You may wish to look at the [./iam.tf](./iam.tf) file where all of these resources are defined.  It may be you need to change some of the values.  Check out the comments in this file. 


