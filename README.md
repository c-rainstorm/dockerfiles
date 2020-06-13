# Dockerfiles

自定义 Dockerfile

- [Dockerfiles](#dockerfiles)
  - [Clone 并配置全局变量](#clone-并配置全局变量)
  - [项目级配置](#项目级配置)
  - [OS](#os)
    - [CentOS](#centos)
  - [JDK](#jdk)
  - [Redis](#redis)
  - [RocketMQ](#rocketmq)

## Clone 并配置全局变量

```bash
git clone https://github.com/c-rainstorm/dockerfiles.git && \
    cd dockerfiles && \
    sed -i.bak -E "s/^DOCKERFILES_ROOT/#DOCKERFILES_ROOT/g" setenv.sh && \
    echo "DOCKERFILES_ROOT=`pwd`" >> setenv.sh && \
    cd -
```

tip:

`sed` 命令的 `-i.bak` 参数，会在替换 `setenv.sh` 前保存一份副本，名称为 `setenv.sh.bak`。

## 项目级配置

```bash
# 整个项目的环境变量

## docker 仓库命名空间
DOCKER_REPOSITORY_NAMESPACE=rainstorm

## 本项目的根目录，clone 到本地后需要自行修改，
## 或者使用上面的命令 Clone 仓库，命令会自动注释掉本行然后根据实际目录生成配置
DOCKERFILES_ROOT=/Users/chen/workspace/docker/dockerfiles
```

## OS

### CentOS

|状态|Dockerfile|备注|Shell|环境变量|
|:---:|:---|:---|:---:|:---|
|Done|[CentOS 7](os/centos/7/)|基于CentOS7简单定制|bash|SOFT_ROOT_DIR=/opt|

## JDK

|状态|Dockerfile|备注|
|:---:|:---|:---|
|Done|[Oracle-JDK(版本支持自定义)](jdk/oracle)|基于[CentOS7](#centos)|

## Redis

|状态|Dockerfile|备注|
|:---:|:---|:---|
|Done|[Redis源码编译(版本支持自定义)](redis)|基于[CentOS7](#centos)|

## RocketMQ

|状态|Dockerfile|备注|
|:---:|:---|:---|
|Done|[直接使用 bin-release 包](rocketmq)|基于[oracle-jdk:1.8.0_191](#jdk)，RocketMQ-4.7.0|
