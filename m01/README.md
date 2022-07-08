

```
kubectl edit cm -n kube-system aws-auth
```


Add: 

```
- groups:
      - system:masters
      rolearn: arn:aws:iam::188966951897:role/eks_dude_role
      username: devops:{{SessionName}}
```