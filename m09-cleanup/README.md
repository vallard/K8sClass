# Clean Up

## m08 

```
 k delete -f m08-app-logging/app-api.yaml
 helm uninstall -n fluentd fluentd
 k delete ns fluentd
 ```

## m07

```
k delete -f m07-fek/kibana-proxy.yaml
```

## m05

```
k delete -f m05/servicemonitor.yaml
k delete -f m05/k8s-configMap.yaml
```


## m03 clean up

```
helm uinstall -n monitoring kube-prom
k delete -f m03/supporting.yaml
```


## m02 clean up

```
k delete -f app-fe/app-fe.yaml 
k delete -f app-api/app-api.yaml
aws secretsmanager delete-secret --secret-id <arn> --force-delete-without-recovery
helm uninstall external-secrets -n kube-system
cd app-api
make clean 
```

## Intro cleanup

```
k delete -f 04/default-backend.yaml
k delete -f 04/cert-manager/prod-issuer.yaml
k delete -f 04/cert-manager/cert-manager.yaml
k delete -f 04/nginx-ingress-controller/deploy.yaml
cd terragrunt/stacks/stage-mon
terragrunt run-all destroy

```
