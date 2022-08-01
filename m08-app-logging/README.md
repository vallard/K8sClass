# Application Logging

One way we can ensure we have a handle on what our application is doing is by having a centralized logging area where all our logs are created.  

Since we already have fluent set up, let's log everything in our application and test it out. Then we can filter the logs to only show logs for our application. 

## Edit Fluentd

Let's not get all those logs, but let's only do the logs for our app: 

```
helm upgrade --install -n fluentd fluentd -f values2.yaml fluent/fluentd
```

## Logs

![](../images/mo/m08-01.png)
