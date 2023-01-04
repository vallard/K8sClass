# 🌎Real World Kubernetes
This is a two part course with practical code examples about running Kubernetes in the real world.  If you want to learn how to run Kubernetes in the real world, this is the course to follow. 

## 👴🏼Older Course Material
I gave several courses on O'Reilly's platform and you may be looking for the code here and find it's organized slightly differently than you might expect it to be.  You can get the old stuff by doing: 

```
git checkout 0f7dd1cb39
```
You should then see all the older README and files. Alternatively you can just [browse at that point on Github here.](https://github.com/vallard/K8sClass/tree/621895ec47b37706d82424814a458c6933008081)

## ✨Introduction to the newer course

This is a revamp of my somewhat popular O'Reilly class EKS in the data center.  I've taken feedback from the hundreds of people who have taken the class to make it more applicable to the real world.  

The class is available on [O'Reilly's platform](https://learning.oreilly.com/home/).  If you have a log in you can search for my name (vallard) there and watch it.  If not, feel free to use this guide and read along. 

This class is one giant demo, so you can probably follow the script easy and do this self paced. Pull requests are welcome if you see errors. 

All content was created by me, [@vallard](https://twitter.com/vallard)



## Part 1 - Kubernetes Real World

### Segment 01 - Setup & Stuff You'll Need
* [Introduction](01/README.md) Read this if you want a background on Kubernetes, Containers, and just getting started. 
* [Tools](01/tools.md) - Read this to get the tools you'll need to run these exercises. 

### Segment 02 - Ignite EKS with Terraform

* [Terraform](02/terraform.md)
* [Terragrunt](02/terragrunt.md)

### Segment 03 - Rapid Cluster Exploration

In this segment we'll go over some Kubernetes primitives.  We move fast, show what they are and what they do. 

* [Exploration](03/README.md)

### Segment 04 - Real World Use Cases

* [Load Balancers](04/ELB.md)
* [Ingress Controllers](04/Ingress.md)
* [Route53 Configureation](04/r53.md)
* [Cert-Manager & Let's Encrypt](04/TLS.md)
* [November Rain: Persistent volumes](04/PV.md)


### Segment 05 - Boss Operations

* [Cluster Autoscaling](05/README.md)
* [Lens & K9s](05/viz.md)
* [Additional Users with Roles and RoleBindings](05/users.md)

### Segment 06 - Putting it together:  Running Your Own App 

* [Create a Python Flask Application from Scratch](06/README.md) 
* [Makefiles, Dockers and Registries](06/README.md)
* [Terraform for DynamoDB](06/README.md)
* [Ta-da!  The app! 🎉](06/README.md)
* [Service Accounts for DynamoDB access](06/README.md)


## Part 2 - 🔭 Kubernetes Monitoring & Observability 

### M01 - Basic Monitoring

* [README](m01/README.md)
* [Metrics API](m01/README.md#03.-Metrics-API)
* [Lens](m01/README.md#04.-Basic-Monitoring-with-lens)
* [k9s](m01/README.md#05.-k9s)

### M02 - Slack App Integration

* [README](m02/README.md)
* [Setup app for Kubernetes](m02/README.md#basic-application)
* [External Secretst](m02/README.md#external-secrets)
* [Application Slack Integration](m02/README.md#applicattion-slack-integration)
* [Application Kubernetes Deployment](m02/README.md#installing-to-kubernetes)

### M03 - Prometheus

* [Intro](m03/README.md)
* [Installation](m03/README.md#installation)
* [Customization](m03/README.md#customization)
* [Explore PromQL](m03/README.md#explore-the-promql-dashbooard)


### M04 - Grafana

* [Intro](m04/README.md)
* [Customization](m04/README.md#customizations)
* [Grafana Slack Alerts](m04/README.md#adding-slack)
* [Create New Dashboard](m04/README.md#$add-a-new-dashboard)
* [Persist Changes](m04/README.md#persist-new-dashboard)

### M05 - Integrate Grafana/Prometheus in our Application

* [Intro](m05/README.md)
* [FastAPI and Prometheus](m05/README.md#fastapi-and-prometheus)
* [Prometheus client](m05/README.md#prometheus-client)
* [Scraping](m05/README.md#scraping)
* [Grafana Integration](m05/README.md#grafana-integration)
* [Persistence](m05/README.md#adding-persistence)

### M06 - CloudWatch Alarms

* [README](m06/README.md)

### M07 - FEK Stack

* [Intro](m07-fek/README.md#components)
* [Configuration](m07-fek/README.md#installation-and-configuration)
* [Fluentd](m07-fek/README.md#fluentd)
* [Kibana](m07-fek/README.md#viewing-logs)


### M08 - Application Logging

* [README](m08-app-logging/README.md)





