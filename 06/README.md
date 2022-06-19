# EKS Dynamo 

This is a quick application that shows how to run an application which accesses AWS components.  In this case, it's dynamoDB!


## Create Dynamo DB Table to test

Run the Terraform command `terraform apply` in this directory to create the DynamoDB table with a user, or you can do it manually as shown below. 

Opening the Dynamo DB console we can create a new table. Our application expects it to be called `dynamoUsers` but we can change it with environment variables if we want.  The primary key we called simply `id`.

To use a different table modify the `DYNAMO_TABLE` environment variable in the `configMap`. 

### Add some test users.

Adding some test users will help us test the display of the data:

| id | email | name |
|----|-------|----------|
| 12345 | mal@auradon.kingdom  | Mal |
| 23445 | queenofmean@auradon.kingdom | Audrey |
 
  
## Build the Container

To test with docker run

```
make build
```

This will create a container called `vallard/eks-dynamo`.  You can test locally on your machine with the following command: 

```
docker run -P -d \
-e REGION=us-east-1 \
-e AWS_ACCESS_KEY_ID=... \
-e AWS_SECRET_ACCESS_KEY=... \
vallard/eks-dynamo 
```

If your environment is configured correctly, it should be able to access the app. 

## Make a private container

ECR is Amazon's private registry for storing your containers.  Create a new container in ECR. 

To now make it so you can update the container from the command line you can follow the instructions in ECR.  You will need to add permissions so your user can login to the registry via the command line.  Add this as an inline policy to the EKSDemoGroup:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1582507843000",
      "Effect": "Allow",
      "Action": [
        "ecr:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```

Update the `Makefile` with your container registry.  When finished, upload the container to ECR with: 

```
make
```


## Create the application

You may wish to update the `eks-dynamo.yaml` with your ingress controller and domain. You may also decide to change the `ConfigMap` with your own table instead of the default.  hint: follow the example with the `REGION` and update `DYNAMODB_TABLE`.

The code is all inside the `app/main.py` file and should be pretty simple to read.  The `app/templates` has the actual html that is rendered. 

Supposing everything else is in place you can now start the application: 

```
kubectl apply -f eks-dynamo.yaml
```

In our example the ingress is set to [dynamo.k8s.castlerock.ai](dynamo.k8s.castlerock.ai).  You should be able to navigate there in a few minutes and vie the page. 

## Add permissions

When you open your application in the web browser you'll see it doesn't quite have permissions.  This will come in a red box at the top as well as any other errors the application enounters.  

We can add dynamo permissions to the role this application is running unders.  Usually the node group of the nodes.  You could also add secrets to the file if you wanted to run under a different user.  

Add to this role the `AmazonDynamoDBFullAccess` and then refresh the page.  If all goes well you should see a page!

![dynamo example](../../images/07-dynamo1.png)


## Service Accounts

We already added the ability for our `eksdude` to create resources.  We can do the following:

```
eksctl utils associate-iam-oidc-provider --cluster dec08 --approve
```
