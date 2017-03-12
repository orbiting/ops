# Ansible

This directory keeps all ansible playbooks, roles and the inventory for Project R. We use them primeraly to provision a new VM and to keep everything up to date.

All our infrastructure managed by ansible (all except docker-machines) is listed in the [inventory](inventory).

## Usage
The usage is documented with the particular machine/role ex. [k8s](../docs/k8s/README.md)
From k8s README (might be outdated):
```
install_ansible_deps.sh k8s-master-0
install_ansible_deps.sh k8s-worker-0
install_ansible_deps.sh k8s-worker-1
... and so on

ansible-playbook site.yml -i inventory -l k8s-*
ansible k8s -i inventory -a "reboot" --become
```

## Secrets
The only secrets we encounter so far with ansible deployments are the ssh keys used to deploy the postgres/barman setup. Check the DB [README](../docs/db/README.md) to see how to handle it.


## Cheats
```
# update all
ansible-playbook playbooks/all/upgrade.yml -i inventory

# reboot all
ansible all -i inventory -a "reboot" --become --ask-pass
```
