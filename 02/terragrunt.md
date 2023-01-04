# Terragrunt

[Terragrunt](https://terragrunt.gruntwork.io/) gives us the ability to reuse multiple modules and keep our environments [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). This is useful for the following reasons: 

1. We can create reusable modules for production and stage environments. 
2. We can string dependencies together.  For example: EKS requires a network, so we can ensure the network is created first and then EKS. 
3. One command to destroy and create all of the different modules.  

In short, Terragrunt can be thought of as an even higher order infrastructure creation tool than Terraform.  It is a wrapper around Terraform and it allows us to organize Terraform into "stacks" of things we want to create. 


Let's create the entire infrastructure as follows: 

```
cd terragrunt/stacks/stage
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all destroy
```

That's it!  

But what are we doing?  In my class I explain these different components in the `stacks` directory and the `modules` directory.  You can also read the Terragrunt documentation to see how it should be organized.  

## Log into the EKS cluster

```
aws eks update-kubeconfig --name eks-stage --alias eks-stage --role-arn arn:aws:iam::188966951897:role/eks_dude_role
```

## Don't Type so much!

Edit `~/.profile` to contain: 

```
alias k='kubectl'
```

Now instead of `kubectl` we can just type `k`. 


