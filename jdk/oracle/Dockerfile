FROM rainstorm/custom-centos:7

ARG JDK_ZIP_FILE
ENV JDK_ROOT_HOME=${SOFT_ROOT_DIR}/java
RUN mkdir -p ${JDK_ROOT_HOME}

RUN wget `if [ ${#HTTPS_PROXY} -gt 0 ]; then echo "--https-proxy ${HTTPS_PROXY}"; fi` https://mirrors.huaweicloud.com/java/jdk/8u191-b12/jdk-8u191-linux-x64.tar.gz

RUN tar -xf jdk-8u191-linux-x64.tar.gz -C ${JDK_ROOT_HOME} && chown -R root:root ${JDK_ROOT_HOME} && rm jdk-8u191-linux-x64.tar.gz

RUN ln -s ${JDK_ROOT_HOME}/`ls ${JDK_ROOT_HOME}|grep jdk` ${JDK_ROOT_HOME}/default

ENV JAVA_HOME=${JDK_ROOT_HOME}/default CATALINA_HOME=${TOMCAT_ROOT_HOME}/default PATH=$PATH:${JDK_ROOT_HOME}/default/bin:${TOMCAT_ROOT_HOME}/default/bin

RUN java -version
