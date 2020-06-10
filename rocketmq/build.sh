#!/bin/bash

source ../setenv.sh

JDK_DIR=${DOCKERFILES_ROOT}/jdk/oracle
ROCKETMQ_ROOT_DIR=${DOCKERFILES_ROOT}/rocketmq

if [ `docker images ${DOCKER_REPOSITORY}/oracle-jdk:1.8.0_191 -q | wc -l` -eq 0 ]; then
    echo "Local ${DOCKER_REPOSITORY}/oracle-jdk:1.8.0_191 not found, try to build"
    echo "Starting build ${DOCKER_REPOSITORY}/oracle-jdk:1.8.0_191"
    cd ${JDK_DIR} && ./build.sh --build-arg HTTPS_PROXY=https://host.docker.internal:1087 && cd ${PWD}
    echo "done"
fi

echo "Starting build rocketmq base image"
docker build -t ${DOCKER_REPOSITORY}/rocketmq:4.7.0 .
echo "done"

echo "Starting build rocketmq-broker image"
cd broker && ./build.sh && cd ${ROCKETMQ_ROOT_DIR}
echo "done"

echo "Starting build rocketmq-ns image"
cd namesrv && ./build.sh && cd ${ROCKETMQ_ROOT_DIR}
echo "done"
