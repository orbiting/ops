#watchtower:
#  image: centurylink/watchtower:latest
#  restart: always
#  environment:
#    REPO_USER: watchtower
#    REPO_PASS:
#    REPO_EMAIL:
#  volumes:
#    - /var/run/docker.sock:/var/run/docker.sock
docker run -d \
  --name watchtower \
  -e REPO_USER="watchtower" -e REPO_PASS="INSERT_PASS" -e REPO_EMAIL="patrick.recher@project-r.construction" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  rosscado/watchtower --debug --interval 10 --apiversion 1.24
