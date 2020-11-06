FROM mysql:5.7

ARG INIT_SQL_FILE

ADD ${INIT_SQL_FILE} /docker-entrypoint-initdb.d

