# Tools You'll Need

## 01. An AWS account

In order to use EKS you'll need to be logged into your own AWS account. [Sign up here](https://aws.amazon.com/).  You'll need a credit card.  Any time you use anything on AWS you will get charged real money.  This class if done for a whole day will cost under $5, but you must make sure you delete all the resources you create.  

## 02. AWS CLI (version 2)

[Official Instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).  

Download this for your appriate operating system. We use the CLI (command line interface) to run AWS commands. 

Note: You may want to set up `AWS_CLI_AUTO_PROMPT` on for command line completion. This is done by setting an environment variable like: 

```
export AWS_CLI_AUTO_PROMPT=on
```
in either `~/.bash_profile` or `~/.zshrc` depending on your shell. 

Make sure that you have `version 2` installed.  

```
aws --version
```
Should show something like: 

```
aws-cli/2.7.6 Python/3.9.11 Darwin/21.5.0 exe/x86_64 prompt/off
```



## 03. AWS Authenticator

[Official Instructions](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

Amazon EKS uses IAM to provide authentication to our Kubernetes clusters.  The authenticator is the way to log into the cluster.  

## 04. `kubectl`

[Official Instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/) 

[kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) is a command line tool used to interact with Kubernetes clusters. 

We install the tool locally on your laptop or jump host where you access kuberentes. 


## 05. `eksctl`

[Official Instructions](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

[eksctl](https://github.com/weaveworks/eksctl) is a tool for managing EKS clusters in AWS via the command line.  We may not use a lot of the features in this class because we set it up with Terraform, but its good to have. 

## 06. `git`

To get started with this class you will need [git](https://help.github.com/en/github/getting-started-with-github/set-up-git).  Then you can clone this repo.  This is done by running: 

```
git clone git@github.com:vallard/K8sClass.git
```

You may instead wish to [fork](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) this repo so you can make modifications. 

I work on a MacBook Pro and have a directory called `~/Code` where I do my work.  Any new repositories I download, I do the following: 

```
cd ~/Code
git clone git@github.com:vallard/K8sClass.git
cd K8sClass
```
Then I am able to use all the code in this repository. 

## 07. `terraform`

[Official Instructions](https://www.terraform.io/downloads)

We don't use any paid for terraform features in this class.  Just the free stuff. 

## 08. `gpg`


GNU Privacy Guard, or the GNU implementation of PGP is used to encrypt and decrypt Terraform secrets. 

I use `brew` to install it on a mac: `brew install gnupg`. 


[This blog post](https://menendezjaume.com/post/gpg-encrypt-terraform-secrets/) is super helpful for getting started using `gpg` with `terraform`. This is our primary use case. 


  




