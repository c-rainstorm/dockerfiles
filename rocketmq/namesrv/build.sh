#!/bin/bash

source ../../setenv.sh

docker build -t ${DOCKER_REPOSITORY_NAMESPACE}/rocketmq-ns:4.7.0 .
