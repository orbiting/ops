# Operations at Project R

## Platform
We host all our services on the IaaS Platform of [exoscale](exoscale.ch)

At the moment we use three different deployment strategies: One the one hand we have several "standalone" docker-machine instances. Each hosting one complete stack for one purpose (ex. gitlab, construction site, etc.).
On the other hand we recently started to setup a kubernetes cluster and are in the process of migrating the docker-machine deployments to that stack.
Beside these we have two postgres instances and barman to back them up, deployed by ansible, directly onto VMs.

Creating the VMs: With the docker-machine approach there is a script (called `0_machine.sh`) that spans the VM. For everything else (postgres, kubernetes, etc.) there are terraform definitions, which makes deploying new machines, or extending existing groups very easy.


TODOs
- [ ] link diagrams
- [ ] make security zones diagram


## Set up your sysadmin machine

### install CLI tools
To interact with our deployments you need to have the following tools installed.
- SSH client (duh!)
- [terraform](https://www.terraform.io/)
- [ansible](http://docs.ansible.com/ansible/intro_installation.html)
- [docker](https://docs.docker.com/engine/installation/)
- kubectl the kubernetes cli tool [kubectl](https://kubernetes.io/docs/user-guide/prereqs/)
- [postgres](https://www.postgresql.org/download/) you just need the client locally.
- [gopass](https://www.justwatch.com/gopass/) / [pass](https://www.passwordstore.org/)


### SSH
Generate your personal ssh keypair for Project R. The pubkey must be copied to the bastion host and to the exoscale web console. Ask you admin fellow to do that.
```
mkdir ~/.ssh/r
ssh-keygen
~/.ssh/r/id_rsa
```

Most of our cloud infrastructure is only accessible via the bastion host. To be able to easly type `ssh k8s-master-0` and still connect via the bastion, add the following snipped to your ~/.ssh/config
```
Host bastion bastion.project-r.construction
  Hostname bastion.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa

Host monitor monitor.project-r.construction
  Hostname monitor.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 monitor.project-r.construction 22

Host k8s-master-0 k8s-master -0.project-r.construction
  Hostname k8s-master-0.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 k8s-master-0.project-r.construction 22
Host k8s-worker-0 k8s-worker-0.project-r.construction
  Hostname k8s-worker-0.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 k8s-worker-0.project-r.construction 22
Host k8s-worker-1 k8s-worker-1.project-r.construction
  Hostname k8s-worker-1.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 k8s-worker-1.project-r.construction 22
Host k8s-worker-2 k8s-worker-2.project-r.construction
  Hostname k8s-worker-2.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 k8s-worker-2.project-r.construction 22
Host k8s-worker-disk-0 k8s-worker-disk-0.project-r.construction
  Hostname k8s-worker-disk-0.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 k8s-worker-disk-0.project-r.construction 22
Host k8s-worker-edge-0 k8s-worker-edge-0.project-r.construction
  Hostname k8s-worker-edge-0.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 k8s-worker-edge-0.project-r.construction 22
Host k8s-worker-edge-1 k8s-worker-edge-1.project-r.construction
  Hostname k8s-worker-edge-1.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 k8s-worker-edge-1.project-r.construction 22

Host barman barman.project-r.construction
  Hostname barman.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 barman.project-r.construction 22

Host db1.staging db1.staging.project-r.construction
  Hostname db1.staging.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 db1.staging.project-r.construction 22

Host db1 db1.project-r.construction
  Hostname db1.project-r.construction
  UserKnownHostsFile ~/.ssh/r/known_hosts
  IdentityFile ~/.ssh/r/id_rsa
  ProxyCommand ssh -q bastion nc -q0 db1.project-r.construction 22
```

### bin
Add the `ops/bin` directory to your path.

in .zshrc or .bashrc
```
export PATH=$PATH:$HOME/project-r/src/ops/bin
```


## Secrets
We manage our passwords and keys with [gopass](https://github.com/justwatchcom/gopass). Checkout the repository like this
```
gopass clone https://git.project-r.construction/admins/pass r  # clone as mount called: r
```


## Services

### bastion
We use a bastion to connect to the cloud network. See install instructions here: [bastion](docs/bastion/README.md)

### DB (Postgres)
We use postgres as our main DB backend. See install instructions here: [db](docs/db/README.md)

### Kubernetes
To orchestrate our containers we use a self-hosted kubernetes cluster. See install instructions here: [README](docs/k8s/README.md)


## Cheats

### Ansible
```
# update all
ansible-playbook playbooks/all/upgrade.yml -i inventory

# reboot all
ansible all -i inventory -a "reboot" --become --ask-pass
```

### Kubernetes
https://kubernetes.io/docs/user-guide/kubectl-cheatsheet/
```
# which pods run on which node
kubectl get po -o wide --all-namespaces
```


## TODOs
- [ ] Setup a backup server, that gathers and secures all our data.
- [ ] Setup prometheus on all machines and install a central monitoring with grafana.


## Sources
- http://askubuntu.com/questions/311447/how-do-i-ssh-to-machine-a-via-b-in-one-command
- https://www.exoscale.ch/syslog/2016/01/15/secure-your-cloud-computing-architecture-with-a-bastion/
- http://unix.stackexchange.com/questions/140853/securely-tunnel-port-through-intermediate-host
- https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-14-04
- http://docs.pgbarman.org/release/2.1/
- https://www.exoscale.ch/syslog/2016/09/14/terraform-with-exoscale/
