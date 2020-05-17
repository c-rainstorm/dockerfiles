FROM rainstorm/custom-centos:7

ARG REDIS_VERSION

ADD redis-${REDIS_VERSION}.tar.gz ${SOFT_ROOT_DIR}/redis

RUN ln -s ${SOFT_ROOT_DIR}/redis/redis-${REDIS_VERSION} ${SOFT_ROOT_DIR}/redis/default && \
    cd ${SOFT_ROOT_DIR}/redis/default && make -j4 install && redis-server --version

EXPOSE 6379

ENTRYPOINT [ "redis-server" ]
