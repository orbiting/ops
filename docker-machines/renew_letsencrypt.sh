#!/bin/bash

#export DOCKER_API_VERSION=1.22
machines=( "construction" "staging.construction" "everythingbutcat" "git" "mattermost" "nextcloud" "piwik" "runner-0" )
for i in "${machines[@]}"
do
  cd "$i" &&
  echo "MACHINE: $i IN $(pwd)" &&
  eval $(docker-machine env $i) &&
  docker ps &&
  echo "ACTION: source .env" &&
  source .env ||
  echo "ACTION: docker-compose down" &&
  docker-compose down &&
  echo "ACTION: ./2_provision.sh" &&
  ./2_provision.sh &&
  echo "ACTION: docker-compose up -d" &&
  docker-compose up -d
  echo "FINISH: $i"
  echo " "
  cd ..
done
echo "FINISH all"
