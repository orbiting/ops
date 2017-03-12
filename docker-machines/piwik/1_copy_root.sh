MACHINE="piwik"
docker-machine ssh $MACHINE "sudo mkdir -p /docker/data/; sudo mkdir -p /docker/etc/" && \
docker-machine scp -r ./root/docker/etc/ $MACHINE:~/etc_tmp  && \
docker-machine ssh $MACHINE "sudo cp -r ~/etc_tmp/* /docker/etc/; rm -rf ~/etc_tmp/"
