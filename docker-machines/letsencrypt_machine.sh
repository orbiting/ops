#!/bin/bash
if [ -z "$1" ]
  then
    echo "supply docker-machine name as first argument"
    exit 1
fi
if [ -z "$2" ]
  then
    echo "supply domain(s) as second argument"
    exit 1
fi

MACHINE=$1
DOMAINS=$2

#copy local id_rsa.pub to docker machine
localKey=$(cat ~/.ssh/id_rsa.pub) \
&& docker-machine ssh $MACHINE "cd .ssh; cp authorized_keys authorized_keys_original; echo "$localKey" >> authorized_keys"

USER="ubuntu"
IP=$(docker-machine ip $MACHINE)

# instal ansible's dependencies
ansible $IP -i "$IP," -vv -u $USER --become-user=root -m raw -a "sudo apt-get --yes install python2.7 python-simplejson"

# add host to inventory and run ansible
echo -e "[letsencrypt]\n$IP" > /tmp/inventory
cat /tmp/inventory
ansible-playbook -vv -i /tmp/inventory -e "remote_user=$USER email=admin@project-r.construction domains=$DOMAINS" ../letsencrypt_ansible.yml
rm /tmp/inventory

# cleanup ssh key
docker-machine ssh $MACHINE "cd .ssh; mv authorized_keys_original authorized_keys"
