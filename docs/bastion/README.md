# Bastion

The bastion is used, to connect to the "internal" network from outside.

## Create
Manually create a new machine via the exoscale web console.

Parameters:
 - hostname: bastion
 - type: small
 - keypair: your personal keypair
 - security groups: management

Upsert the dns entry with the IP of the newly created machine: bastion.project-r.construction
TODO: automate this

See [README](../README.md) for how to add the host to your ssh config.

## Provision
```
install_ansible_deps.sh bastion
ansible-playbook site.yml -i inventory -l bastion
ansible bastion -i inventory -a "reboot" --become
```

## Sources
- https://www.exoscale.ch/syslog/2016/01/15/secure-your-cloud-computing-architecture-with-a-bastion/
