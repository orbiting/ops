# DBs

Postgres rules our main DB backend.

## Create
Manually create a new machines via the exoscale web console.

Parameters:
 - hostname: barman, db1.staging, db1
 - type: small
 - disk: 50 GB
 - keypair: your personal keypair
 - security groups: staging / production
 - anti-affinity: postgres-staging

Upsert the dns entries with the IP of the newly created machines.

See [README](../README.md) for how to add the host to your ssh config.


## Configure

### Secrets / SSH keys
The SSH keys for DB need to be placed on barman and vice versa. To simplify the automation, we decided to generate the keys before hand and copy them to the machines. Therefor you have to get the keys first, and copy them to the appropriate location within ansible.
- get the keys from our pass repo
- copy them to ansible/playbooks/postgres/files


### barman
```
install_ansible_deps.sh barman
ansible-playbook site.yml -i inventory -l barman
```

### DBs
copy the ip of barman to `playbooks/postgres/host_vars/HOSTNAME` first
```
install_ansible_deps.sh db1.staging
install_ansible_deps.sh db1

ansible-playbook site.yml -i inventory -l db1*
```

### Barman
After both db and barman are provisoned we have to initialize barman manually.
Run on barman:
```
barman receive-wal --create-slot db1.staging
barman check db1.staging

#check if barman cron runs:
less /var/log/barman/cron.log
```

## Cheats
Make a new backup
```
barman backup db1.staging

```

Recover a backup to a remote host (from db1.staging to db1)
```
barman list-backup db1.staging
barman recover db1.staging 20170220T124122 /var/lib/postgresql/9.6/main --remote-ssh-command "ssh postgres@db1.project-r.construction"
```


## Sources
- https://www.postgresql.org/docs/9.6/static/warm-standby.html#STREAMING-REPLICATION
- https://github.com/2ndQuadrant/repmgr
- https://github.com/ANXS/postgresql/blob/0ed39ed89b380edafba18e585c9ad116b6f90b09/defaults/main.yml
- https://github.com/ANXS/postgresql
