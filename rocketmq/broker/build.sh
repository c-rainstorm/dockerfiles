#!/bin/bash

source ../../setenv.sh

docker build -t ${DOCKER_REPOSITORY}/rocketmq-broker:4.7.0 .
