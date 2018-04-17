# Deploying Open Cabinet to Kubernetes

This document steps through how to deploy the rails application and postgres database into a kubernetes cluster. There are two way to do this: a) by running kubectl commands with deployment files, and b) helm charts (not supported yet.)

## Manually

This method of deployment is useful when using minikube or for CI purposes.

### Secrets

Create the necessary secrets:

```bash
kubectl create secret generic secret-key-base --from-literal=secret-key-base=d9c69d37907ea27c1970faf75661433eb8ac11e725bece21fc32ca76274c40b0bb404b09548aa7441e1f801a04f10612c1d104b5388d41c525a9012621dcae01
kubectl create secret generic db-username --from-literal=username=thebestusername
kubectl create secret generic db-password --from-literal=password=thebestpassword
```

### Postgres DB

Create the volumes, service, and deployment for postgres:

```bash
kubectl create -f kube/volumes/postgres.yaml
kubectl create -f kube/services/postgres.yaml
kubectl create -f kube/deployments/postgres.yaml
```

### Application

Ensure that:
- the Docker image is built and pushed to the docker registry that kubernetes can reach.
- The postgres DB has been created and is available (see `kubectl describe deployments -l app=open-cabinet`)

Create the database and run migrations then follow along to track progress:

```bash
kubectl create -f kube/jobs/setup.yaml
kubectl logs -f job/open-cabinet-setup
```
Note: if the job fails for any reason you can get more details with `kubectl describe job/open-cabinet-setup` and eventually delete the job with `kubectl delete job open-cabinet-setup` (or alternatively `kubectl delete -f kube/jobs/setup.yaml`). Troubleshooting involves attaching to the running job with `kubectl exec -it <pod-name> -- /bin/bash`.


Create the service and deployment objects for the rails application
```bash
kubectl create -f kube/deployments/rails.yaml
kubectl create -f kube/services/rails.yaml
```

### Ingress

Note: If you are running this in minikube you must run `minikube addons enable ingress` first!

To enable an external route to the rails service create the Ingress object:

```bash
kubectl create -f kube/ingresses/rails.yaml
```

## Using Helm Charts

Not supported yet.