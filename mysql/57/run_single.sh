#!/bin/bash -x

# ./run_single.sh --network sparrow

NAME=mysql_sparrow
# INIT_SQL_FILE_ORIGIN=/Users/chen/workspace/docker/apollo/scripts/sql/apolloportaldb.sql
# INIT_SQL_FILE_ORIGIN=/Users/chen/workspace/docker/apollo/scripts/sql/apolloportaldb.sql
# INIT_SQL_FILE=setup.sql
# IMAGE=rainstorm/mysql:5.7
MOUNT_VOLUMN=/tmp/mysql
IMAGE=mysql:5.7
# if [ `docker images ${IMAGE} -q |wc -l` -eq 0 ]; then
#     docker pull ${IMAGE} > /dev/null
# fi

# if [ `docker images ${IMAGE} -q |wc -l` -eq 0 ]; then
#     docker build `if [ ${#INIT_SQL_FILE_ORIGIN} -gt 0 ] && [ -f ${INIT_SQL_FILE_ORIGIN} ] ; then cat ${INIT_SQL_FILE_ORIGIN} > ${INIT_SQL_FILE} && echo "--build-arg INIT_SQL_FILE=${INIT_SQL_FILE}"; fi` -t=${IMAGE} .
#     rm ${INIT_SQL_FILE}
# fi

mkdir -p ~/.password
MYSQL_PASS_FILE=~/.password/mysql
echo "######################################################"
if [ ! -e ${MYSQL_PASS_FILE} ] || [ `cat ${MYSQL_PASS_FILE} | wc -l` -eq 0 ]; then
    openssl rand -base64 10 > ${MYSQL_PASS_FILE}
    echo "new password generated, find it in ${MYSQL_PASS_FILE}"
else
    echo "use password in ${MYSQL_PASS_FILE} generated before"
fi
echo "######################################################"

if [ `docker container ls --filter=name=${NAME} -q | wc -l` -gt 0 ]; then
    echo "stopping container [${NAME}]"
    docker container stop ${NAME}
    echo "done"
fi

if [ `docker container ls -a --filter=name=${NAME} -q | wc -l` -gt 0 ]; then
    echo "removing container [${NAME}]"
    docker container rm ${NAME}
    echo "done"
fi

MYSQL_RUNTIME_CONFIG_FLAGS=""

echo "character-set-server -> utf8mb4"
MYSQL_RUNTIME_CONFIG_FLAGS="${MYSQL_RUNTIME_CONFIG_FLAGS} --character-set-server=utf8mb4"
echo "collation-server -> utf8mb4_unicode_ci"
MYSQL_RUNTIME_CONFIG_FLAGS="${MYSQL_RUNTIME_CONFIG_FLAGS} --collation-server=utf8mb4_unicode_ci"

docker run `echo $@` --name ${NAME} -p 3306:3306 -v ${MOUNT_VOLUMN}:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=`cat ${MYSQL_PASS_FILE}` \
    -d ${IMAGE} ${MYSQL_RUNTIME_CONFIG_FLAGS}
