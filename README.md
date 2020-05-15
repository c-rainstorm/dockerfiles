# Dockerfiles

自定义 Dockerfile

- [Dockerfiles](#dockerfiles)
  - [OS](#os)
    - [CentOS](#centos)
  - [JDK](#jdk)
  - [Redis](#redis)

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
