# Clean Up

We don't want to be charged a ton of money, so after the end of this class, we clean it all up.  



## Terragrunt Clusters

```
cd 01/terragrunt/live/prod
terragrunt run-all destroy
cd 01/terragrunt/live/stage
terragrunt run-all destroy
```


## Initial Cluster

```
cd 01/terraform/eks
terraform destroy
cd 01/terraform/network
terraform destroy
cd 01/terraform/iam
terraform destroy 
```