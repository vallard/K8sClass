# AWS Credentials

In order to use EKS you'll need to be logged into your own AWS account with the credentials available on the command line. 

You'll need to do the following: 

* Install AWS CLI
* Ensure you have profile setup for AWS CLI
* Set up multiple profiles if necessary

## Install AWS CLI tool

[Official instructions are here.](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html). We will be using the version 1 client. 

It requires python.  This should be a prerequisite of this class, so we don't go into detail on how to install python nor pip. But don't worry, if you don't have this there are lots of documentation found with a simple internet search for your operating system. 

```
pip3 install awscli --upgrade --user
```

## Configure AWS CLI

If you have multiple AWS accounts you probably don't want to override your current settings. 

In my setup I have 2 different AWS clouds I work with (usually).  Previously I had just set the environment variables in the `~/.bash_profile` as: 

```
export AWS_ACCESS_KEY_ID=AKI...
export AWS_SECRET_ACCESS_KEY=jZ....
export REGION=us-east-1
```
While this works great if you have one environment it doesn't allow you to switch between the two or three environments you might want.

### Get CLI credentials

[Explained here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) you can log into the console and get your credentials. If you only have one environment you are using environment variables work well.  Note that environment variables supersede whatever you set in the aws configuration file. 

### Named Credentials

[Named profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) give us a way to access two or more environments easily. 

We first run: 

```
aws configure
```
and follow the prompts to get our default profile set up.  Then we can configure our next profile with: 

```
aws configure --profile cr
```
This will configure a second profile named cr that you can use. 

Additionally, you can configure your named profile through modifying the `~/.aws/credentials` and the `~/.aws/config` file. 

When finished, test your configurations:

```
aws ec2 describe-instances
```

Test the other profile: 

```
aws ec2 describe-instances --profile cr
```

If you get an error like: 

```
An error occurred (UnauthorizedOperation) when calling the DescribeInstances operation: You are not authorized to perform this operation.
```
You should check your IAM profile to make sure you have permission. 


Since you may be working on a particular profile for a while you can set it with an environment variable for the correct profile: 

### Mac

```
export AWS_PROFILE=cr
```

### Windows

```
setx AWS_PROFILE cr
```

Operations only effect new shells and with MacOS the existing shell window.  Previously opened shells will still use the default. 

## Install AWS IAM Authenticator

[Instructions here.](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

The authenticator app gets you access with `kubectl` and is required for EKS. 

### MacOS

```
brew install aws-iam-authenticator
```

### Windows

```
choco install -y aws-iam-authenticator
```

## Bonus:  Command Completer

If you use unix systems, tab completion is a big deal.  You can configure [following these instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html)
