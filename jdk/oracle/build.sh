#!/bin/bash

# ./build.sh --build-arg HTTPS_PROXY=https://host.docker.internal:1087

# 华为云 JDK镜像 https://mirrors.huaweicloud.com/java/jdk/

CENTOS7_DIR=../../os/centos/7
JDK_ROOT=`pwd`

if [ `docker images rainstorm/custom-centos:7 -q | wc -l` -eq 0 ]; then
    echo "Local rainstorm/custom-centos:7 not found, try to build"
    echo "Starting build rainstorm/custom-centos:7"
    cd ${CENTOS7_DIR} && ./build.sh --build-arg HTTPS_PROXY=https://host.docker.internal:1087 && cd ${JDK_ROOT}
    echo "done"
fi

docker build `echo $@` -t=rainstorm/oracle-jdk:1.8.0_191 .
