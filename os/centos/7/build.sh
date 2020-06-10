#!/bin/bash

# https://docs.docker.com/docker-for-mac/networking/
#
# 假设宿主机上 1087 端口有 HTTPS 代理
#
# Docker for Mac
#
# host.docker.internal 可以解析为宿主机IP
# ./build.sh --build-arg HTTPS_PROXY=https://host.docker.internal:1087
#
# linux 下可以使用 --network host 和宿主机共享网络，然后 --build-arg HTTPS_PROXY=https://localhost:1087 启用代理
# # ./build.sh --network host --build-arg HTTPS_PROXY=https://host.docker.internal:1087
#

docker build `echo $@` -t=rainstorm/custom-centos:7 .
