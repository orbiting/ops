# Dockers

This repository holds the files used to setup our "standalone" docker-machine silos. We are in the process of migrating these into the Kubernetes cluster.


## Usage

### Create an existing machine
To create a machine, you need to be in possesion of the exoscale API key and secret. Out of security reasons they are not checked into the git repo. Get them from our `pass` store and set them as ENV variables exoscaleApiKey and exoscaleApiSecret.
```
export exoscaleApiKey="INSERT"
export exoscaleApiSecret="INSERT"
```

Most environment variables contain secret information like keys. To keep them out of the docker-compose.yml file we use a .env file in each of the machines directories (not in git, get them from the admin) and just reference the env vars inside the docker-compose.yml. So in order to interact with docker-compose files, you need to source the .env file first. See [this](https://docs.docker.com/compose/environment-variables/#passing-environment-variables-through-to-containers) and the following examples for how this works.


As an example, here are the steps used to setup the machine `nextcloud`
```
cd docker-machines/nextcloud
./0_machine
./1_copy_root.sh

docker-machine ip nextcloud
# add DNS entry: A nextcloud -> <IP>
./2_provision.sh

source .env
eval $(docker-machine env nextcloud)
docker-compose up -d
```

### Update a machine to the newest images (deploy an update)
```
cd construction
source .env
eval $(docker-machine env construction)
docker-compose pull      # or
docker-compose pull node # to only pull the app image
docker-compose down && docker-compose up -d
```

### Renew letsencrypt certificates
```
./renew_letsencrypt.sh
```

### Change the config of a service on a machine
Edit the files found in `dockers/machine_name/root/docker/` then run:
```
source .env
./1_copy_root.sh
eval $(docker-machine env machine_name)
docker-compose down && docker-compose up -d
```

### Change the containers on a machine
Adapt the docker-compose file of the machine to your needs. Then run:
```
source .env
vi docker-compose.yml
eval $(docker-machine env machine_name)
docker-compose down && docker-compose up -d
```
