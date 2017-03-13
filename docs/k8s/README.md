# Kubernetes

The k8s cluster setup of Project R


## Setup networking
we run the [exoscale ansible playbook](https://github.com/exoscale/multi-master-kubernetes) first. Then deleted the VMs but are now using the security group setup from there.
TODO: extract security group from ansible and/or implement in terraform
open

## Create
Run the terraform scripts to create the swarm managers and nodes.
```
ops/terraform
terraform apply
```
Upsert the dns entry with the IP of the newly created machines.
TODO: automate this annoying step.

See [README](../README.md) for how to add the host to your ssh config.

## Configure
```
install_ansible_deps.sh k8s-master-0
install_ansible_deps.sh k8s-worker-0
install_ansible_deps.sh k8s-worker-1
... and so on

ansible-playbook site.yml -i inventory -l k8s-*
ansible k8s -i inventory -a "reboot" --become
```
TODO: automate this


Manually join together the nodes by the following procedure. This could be automated, but I didn't find the time so far.
```
ssh k8s-master-0
ifconfig
sudo kubeadm init --api-advertise-addresses IP
# install canal for networking
kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/kubeadm/canal.yaml

# remember the printed commands and apply them on the workers
sudo kubeadm join --token=TOKEN IP
kubectl get nodes
```


### ingress (traefik)
We use traefik on two edge nodes for ingress loadbalancing.
```
# Assign the edge-router role
kubectl label node k8s-worker-edge-0 role=edge-router
kubectl label node k8s-worker-edge-1 role=edge-router

# mark k8s edge workers as unschedulable (they run anything except traefik
kubectl cordon k8s-worker-edge-0
kubectl cordon k8s-worker-edge-1

# schedule traefik
kubectl apply -f traefik.yaml
kubectl apply -f traefik_ui.yaml
```

### metrics: weavescope and dashboard
```
weavescope is an opensource standalone dashboard for easy insights.
https://www.weave.works/documentation/scope-latest-installing/#k8s
kubectl create namespace weavescope
kubectl apply -f weavescope.yaml

# install dashboard
kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml

# connect to weavescope
kubectl port-forward $(kubectl get pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}') 4040

# connect to dashboard
kubectl proxy
```

### fileserver
We use nginx to quickly serve static files
```
cd fileserver
# kubectl create configmap fileserver-config --from-file=conf.d
kubectl create configmap static-files --from-file=static_files
kubectl apply -f nginx.yaml
kubectl apply -f nginx_service.yaml
```

### deploy R apps
```
# first create a secret for the gitlab container registry
kubectl create secret docker-registry project-r-registry-secret --docker-server=registry.git.project-r.construction --docker-username=docker-bot --docker-password= --docker-email=docker-bot@project-r.construction
```

#### deploy cms-draft
```
kubectl create secret generic cms-draft-secrets \
 --from-literal=SESSION_SECRET="" \
 --from-literal=GITHUB_CLIENT_ID="" \
 --from-literal=GITHUB_CLIENT_SECRET=""
kubectl apply -f cms-draft.yaml
kubectl apply -f cms-draft_service.yaml
```

#### deploy cf_server
```
kubectl create secret generic cf-server-secrets \
 --from-literal=SESSION_SECRET="" \
 --from-literal=DATABASE_URL=""
kubectl apply -f cf_server.yaml
kubectl apply -f cf_server_service.yaml
```


## Cheatsheet
https://kubernetes.io/docs/user-guide/kubectl-cheatsheet/
```
kubectl get po -o wide --all-namespaces
```

## Sources
- https://kubernetes.io/docs/getting-started-guides/kubeadm/
- https://hackernoon.com/kubernetes-ingress-controllers-and-traefik-a32648a4ae95#.tvfsr6qlu
- https://kubernetes.io/docs/user-guide/secrets/#using-secrets-as-environment-variables
- https://archifleks.github.io/blog/kubernetes-ingress/
- http://stackoverflow.com/questions/39293441/needed-ports-for-kubernetes-cluster
- https://coreos.com/kubernetes/docs/latest/kubernetes-networking.html#pod-to-pod-communication
