#!/bin/bash

set -e

cd "$(dirname "$(realpath -s "$0")")/$1"

docker-compose down -v
docker-compose rm -fv

# Remove old containers, images and volumes
VOLUMES="$(docker volume ls -qf "name=$1_")"
NETWORKS="$(docker network ls -qf "name=$1_")"
CONTAINERS="$(docker ps -aqf "name=$1_*")"

# NOTE we want word splitting, don't quote the variables
[[ -n "$VOLUMES" ]] && docker volume rm $VOLUMES
[[ -n "$NETWORKS" ]] && docker network rm $NETWORKS
[[ -n "$CONTAINERS" ]] && docker rm $CONTAINERS

cat << EOF > .env
UID=$(id -u)
GID=$(id -g)
FQDN=$(hostname -f)
USERNAME=$(id -un)
EMAIL=will.brannon@gmail.com
EOF

docker-compose up -d --build --remove-orphans

