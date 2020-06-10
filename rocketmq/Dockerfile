FROM rainstorm/oracle-jdk:1.8.0_191

# Dockerfile 大部分拷贝自 https://github.com/apache/rocketmq-docker

RUN yum install -y wget unzip

ARG user=rocketmq
ARG group=rocketmq
ARG uid=3000
ARG gid=3000

# RocketMQ is run with user `rocketmq`, uid = 3000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN groupadd -g ${gid} ${group} \
    && useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user}

ENV ROCKETMQ_VERSION 4.7.0

ENV ROCKETMQ_HOME  /home/rocketmq/rocketmq-${ROCKETMQ_VERSION}

RUN mkdir -p ${ROCKETMQ_HOME}

# 此处固定使用清华镜像源，如果下载速度不行可以从 apache 网站查找最快的镜像源
# https://www.apache.org/dyn/closer.cgi?path=rocketmq/4.7.0/rocketmq-all-4.7.0-bin-release.zip
RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip; \
        unzip rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip ; \
        mv rocketmq-all*/* ${ROCKETMQ_HOME} ; \
        rmdir rocketmq-all*  ; \
        rm rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip

RUN chown -R ${uid}:${gid} ${ROCKETMQ_HOME}

# export Java options
RUN export JAVA_OPT=" -Duser.home=/opt"

# Add ${JAVA_HOME}/lib/ext as java.ext.dirs
RUN sed -i 's/${JAVA_HOME}\/jre\/lib\/ext/${JAVA_HOME}\/jre\/lib\/ext:${JAVA_HOME}\/lib\/ext/' ${ROCKETMQ_HOME}/bin/tools.sh

USER ${user}

WORKDIR ${ROCKETMQ_HOME}/bin
