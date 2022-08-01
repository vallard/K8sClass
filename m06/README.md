# CloudWatch Logging

With EKS we don't get access to the control plane.  It is managed for us.  However, sometimes it is helpful to get access to the control plane logs to see what is happening.  

## Enable Control plane metrics

We can do this by modifying our cluster to export logs.  (The Terragrunt we set up didn't do this before.)

To do this we follow the [instructions](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) and run: 

```
aws eks update-cluster-config \
    --region us-west-2 \
    --name eks-stage-mon \
    --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
```

## Analyzing metrics in Cloud Watch


We visit [CloudWatch](https://console.aws.amazon.com/cloudwatch/home#logs:prefix=/aws/eks) and search for the prefix `/aws/eks`.  This should show all our clusters. 


There are several different logs we can see: 



* Kubernetes API server component logs (api) – kube-apiserver-<nnn...>
* Audit (audit) – kube-apiserver-audit-<nnn...>
* Authenticator (authenticator) – authenticator-<nnn...>
* Controller manager (controllerManager) – kube-controller-manager-<nnn...>
* Scheduler (scheduler) – kube-scheduler-<nnn...>

Past metrics that happened before the logging was enabled won't be visible, so we can't see things like the API server flags, etc. 

You can see different authentication sessions, etc. 

## Setting Alarms for EKS

One particular alarming event may be if the control plane stops sending metrics.  For example, you may be monitoring everything on your cluster, but if your cluster stops working then you won't have any alerts!  So monitoring the control plane to make sure it doesn't go down is a good alarm to set. 

To do this we would: 

* Set an SNS topic
* Have Slack/ Pager Duty subscribe to this SNS group
* Have the alarm monitor EKS traffic and alert if there is no data or there is less than 20 logs in a 5 minute period. 

In future classes we may add how to do this explicitly to this section. 

## Disabling control plane metrics

aws eks update-cluster-config \
    --region us-west-2 \
    --name eks-stage-mon \
    --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":false}]}'
