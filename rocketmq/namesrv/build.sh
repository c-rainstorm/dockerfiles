#!/bin/bash

source ../../setenv.sh

docker build -t ${DOCKER_REPOSITORY}/rocketmq-ns:4.7.0 .
