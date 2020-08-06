# Serverless With Kubernetes

We can make our serverless functions work with our Kubernetes cluster.  Why would we want to do that? 

* Have serverless functions trigger jobs
* Have serverless functions create workloads for different projects. 

As an example in our company we created a [Matomo](https://matomo.org) service. When people would sign up we would deploy a matomo instance for them.  Instead of creating VMs we would have it create several kubernetes constructs including: 

* Deployment for Database
* Deployment for Matomo
* Service for Matomo and Database
* TLS generation for ingress rules for Matomo
* Secret files for Matomo for passwords,etc. 

Let's show a quick example of how we made this happen. 

## The example

Our function will simply list all the pods in the cluster.  This is the equivalent of running: `kubectl get pods --all-namespaces`.  Pretty simple, but getting to work in AWS lambda with API Gateway is decidedly not simple!  However, this quick example can make it much easier. 

### Serverless

The [serverless.com](https://serverless.com) framework allows you to create serverless functions with AWS.

#### Build the serverless environment. 

The serverless environment is built on node.  If you don't know node then there are lots of places to learn, however this is beyond the scope of this class. Check out [the serverless.com website](https://serverless.com) for instructions on getting started.

```
cd segment07*/
npm install serverless-python-requirements
```

#### Make a role we can assign

Our lambda function needs to run as a certain role.  We can define this role and give it all the EKS permissions it needs.  If you need your serverless configuration to have access other resources then you should add to the role as well.  Make note of the role arn. 

#### Edit the `serverless.conf` file

We need to update the role to put in the one we just created: 

```yaml
service: EKSless
provider:
  name: aws
  runtime: python3.7
  region: us-west-2 # change this to be your region
  environment:
    ## Define the name of your EKS cluster you want the lambda function to be able to access
    CLUSTER: "<your cluster name here>"
  ## define the role that this lambda function will run under.  This role should have access to
  ## be able to run kubectl commands.
  role: <your role arn:aws:iam::12343455:role/kubeLambda>
```

Test locally with: 

```
sls invoke local -f list
```

This should list all your kubernetes pods in the cluster. 

### Add permissions

Your user may not have permissions to access CloudWatch Logs, API Gateway, or Lambda services.  You can create a policy and add to the group.  The `serverless` policy can look as follows: 

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "apigateway:*",
                "logs:*",
                "lambda:*"
            ],
            "Resource": "*"
        }
    ]
}

```

After adding this policy to the `EKSDemoGroup` you should be able to deploy the serverless function. 

### Deploy serverless function

You can then deploy this with: 

```
sls deploy
```

Now we can list our Kubernetes deployments in our cluster with: 

```
sls invoke -f list
```

If you need to update: 

```
sls deploy -f list
```

To see logs: 

```
sls logs -f list
```

You can simply curl the application to see all the pods: 

```
curl https://0qtyabihgc.execute-api.us-west-2.amazonaws.com/dev/list | jq
```

The output looks similar to the following: 

```json
{
  "pods": [
    {
      "ip": "192.168.14.34",
      "namespace": "cert-manager",
      "name": "cert-manager-69779b98cd-vbsl9"
    },
    {
      "ip": "192.168.29.92",
      "namespace": "cert-manager",
      "name": "cert-manager-cainjector-7c4c4bbbb9-tttbs"
    },
    ...
  ]
}
```
These are the pods in our cluster. 

