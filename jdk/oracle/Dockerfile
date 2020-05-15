FROM rainstorm/custom-centos:7

ARG JDK_ZIP_FILE
ENV JDK_ROOT_HOME=${SOFT_ROOT_DIR}/java
RUN mkdir -p ${JDK_ROOT_HOME}

ADD --chown=root:root ${JDK_ZIP_FILE} ${JDK_ROOT_HOME}

RUN ln -s ${JDK_ROOT_HOME}/`ls ${JDK_ROOT_HOME}|grep jdk` ${JDK_ROOT_HOME}/default

ENV JAVA_HOME=${JDK_ROOT_HOME}/default CATALINA_HOME=${TOMCAT_ROOT_HOME}/default PATH=$PATH:${JDK_ROOT_HOME}/default/bin:${TOMCAT_ROOT_HOME}/default/bin

RUN java -version
