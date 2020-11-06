#!/bin/bash

# ./run.sh

version=1.18
NETWORK=sparrow
CONFIG_FILE=/Users/chen/workspace/docker/dockerfiles/nginx/nginx.conf
NAME=single_nginx_${version}

if [ `docker container ls --filter=name=${NAME} -q | wc -l` -gt 0 ]; then
    echo "stopping container [${NAME}]"
    docker container stop ${NAME}
    echo "done"
fi

if [ `docker container ls -a --filter=name=${NAME} -q | wc -l` -gt 0 ]; then
    echo "removing container [${NAME}]"
    docker container rm ${NAME}
    echo "done"
fi

echo "starting container [${NAME}]"
docker run -d -p 80:80 --network=${NETWORK} --name $NAME \
    -v `pwd`/upstream.d:/etc/nginx/upstream.d \
    -v ${CONFIG_FILE}:/etc/nginx/nginx.conf:ro nginx:${version}
echo "done"

echo "container ip: `docker inspect --format='{{ .NetworkSettings.Networks.'${NETWORK}'.IPAddress }}' $NAME`"
echo "binding local port: `docker port $NAME | awk -F: '{print $NF}'`"
