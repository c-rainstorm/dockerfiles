FROM centos:7

RUN sed -e 's/mirror.centos.org/mirrors.tuna.tsinghua.edu.cn/g' -e 's/mirrorlist=/#mirrorlist=/g' -e 's/#baseurl=/baseurl=/g' /etc/yum.repos.d/CentOS-Base.repo

LABEL author="baochen zhang" email="rainstorm.me@outlook.com"

SHELL [ "/bin/bash", "-c" ]

RUN yum makecache && yum -y update && yum -y install wget telnet gcc-c++ make less man sed openssl

ENV SOFT_ROOT_DIR=/opt
