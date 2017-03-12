# Docker swarm

DEPRECATED: We don't use docker-swarm in our stack anymore!! The document is kept here for archive purposes.

The docker swarm is used to schedule app containers.


## Setup networking
allow communcation inside the `production` security group for docker.
See https://docs.docker.com/engine/swarm/swarm-tutorial/#/open-ports-between-the-hosts


## Create
Run the terraform scripts to create the swarm managers and nodes.
```
ops/terraform
terraform apply
```
Upsert the dns entry with the IP of the newly created machines.

See [README](../README.md) for how to add the host to your ssh config.


## Configure
```
cd ops/ansible
./install_ansible_deps.sh docker-manager-1 docker-manager-2 docker-manager-3 docker-worker-1

ansible-playbook site.yml -i inventory
```

Manually join together the nodes by the following procedure. This could be automated, but I didn't find the time so far.
https://thisendout.com/2016/09/13/deploying-docker-swarm-with-ansible/

```
ssh docker-master-0
ifconfig
docker swarm init --advertise-addr PUBLIC IP
docker swarm join-token manager
docker swarm join-token worker
# remember the printed commands and apply
# them on the remaining masters / workers
```

## Sources
- https://docs.docker.com/engine/swarm/
- https://docs.docker.com/engine/swarm/services/
- https://docs.traefik.io/user-guide/swarm/

- https://www.nginx.com/blog/docker-swarm-load-balancing-nginx-plus/
- https://github.com/nginxinc/NGINX-Demos/tree/master/nginx-swarm-demo
- https://thisendout.com/2016/09/13/deploying-docker-swarm-with-ansible/
