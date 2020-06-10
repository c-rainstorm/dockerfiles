FROM centos:7

RUN sed -e 's/mirror.centos.org/mirrors.tuna.tsinghua.edu.cn/g' -e 's/mirrorlist=/#mirrorlist=/g' -e 's/#baseurl=/baseurl=/g' /etc/yum.repos.d/CentOS-Base.repo

LABEL author="baochen zhang" email="rainstorm.me@outlook.com"

SHELL [ "/bin/bash", "-c" ]

ENV SOFT_ROOT_DIR=/opt

RUN yum makecache && yum -y update && yum -y install wget

# RUN yum -y install wget telnet gcc* make less man sed openssl nmap  net-tools libgnutls-dev zlib1g-dev pkg-config

# RUN export https_proxy=${HTTPS_PROXY} && wget https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0.tar.gz && mkdir -p ${SOFT_ROOT_DIR}/aria2 && tar -xf aria2-1.35.0.tar.gz -C ${SOFT_ROOT_DIR}/aria2

# RUN yum -y install cppunit-devel zlib-devel sqlite3-devel openssl-devel

# RUN rm aria2-1.35.0.tar.gz && cd ${SOFT_ROOT_DIR}/aria2/aria2-1.35.0 && ./configure --without-gnutls --with-openssl && make -j4 install && aria2c -v
