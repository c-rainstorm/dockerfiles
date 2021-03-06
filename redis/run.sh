#!/bin/bash

# ./run.sh --tag=5.0.9 --network=sparrow

function usage() {
    echo "./run.sh [-t[version]] [--tag=[version]] [--network=] [options]"
    echo ""
    echo "[option]"
    echo ""
    echo "-t --tag=[value]      用于运行指定版本的 Redis"
    echo "-t --network=[value]  用于指定容器运行的网络"
    echo "-h --help             帮助文档"
    echo "                   "
    echo "[Example]          "
    echo "                   "
    echo "tag=5.0.9"
    echo "  ./run.sh --tag=5.0.9"
    echo "  ./run.sh -t5.0.9"
}

tag=""
NETWORK=""
while getopts t:h-: opt;do
    case $opt in
        -)
            case $OPTARG in
                help)
                    usage
                    exit 0
                    ;;
                tag=*)
                    tag=${OPTARG#*=}
                    ;;
                network=*)
                    NETWORK=${OPTARG#*=}
                    ;;
            esac
            ;;
        t)
            tag=$OPTARG
            ;;
        h)
            usage
            exit 0
            ;;
        \?)
            usage
            exit 1
            ;;
    esac
done

if [ ${#tag} -eq 0 ]; then
    usage
    exit 1
fi

if [ `docker images redis:${tag} -q |wc -l` -eq 0 ]; then
    docker pull redis:${tag}
fi

mkdir -p ~/.password
REDIS_PASS_FILE=~/.password/redis
echo "######################################################"
if [ ! -e ${REDIS_PASS_FILE} ] || [ `cat ${REDIS_PASS_FILE} | wc -l` -eq 0 ]; then
    openssl rand -base64 10 > ${REDIS_PASS_FILE}
    echo "new password generated, find it in ${REDIS_PASS_FILE}"
else
    echo "use password in ${REDIS_PASS_FILE} generated before"
fi
echo "######################################################"

NAME=single_redis_${tag}

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

REDIS_RUNTIME_CONFIG_FLAGS=""

echo "替换绑定地址  --bind 0.0.0.0"
REDIS_RUNTIME_CONFIG_FLAGS="${REDIS_RUNTIME_CONFIG_FLAGS} --bind 0.0.0.0"

echo "关闭保护模式  --protected-mode no"
REDIS_RUNTIME_CONFIG_FLAGS="${REDIS_RUNTIME_CONFIG_FLAGS} --protected-mode no"

# echo "后台启动 --daemonize yes"
# REDIS_RUNTIME_CONFIG_FLAGS="${REDIS_RUNTIME_CONFIG_FLAGS} --daemonize yes"

echo "使用 ${REDIS_PASS_FILE} 配置密码： --requirepass " '${REDIS_PASS_FILE}'
REDIS_RUNTIME_CONFIG_FLAGS="${REDIS_RUNTIME_CONFIG_FLAGS} --requirepass `cat ${REDIS_PASS_FILE}`"

echo "starting container [${NAME}]"
docker run -d --network=${NETWORK} --name $NAME redis:${tag} ${REDIS_RUNTIME_CONFIG_FLAGS}
echo "done"

echo "container ip: `docker inspect --format='{{ .NetworkSettings.Networks.'${NETWORK}'.IPAddress }}' $NAME`"
echo "binding local port: `docker port $NAME | awk -F: '{print $NF}'`"
# docker inspect --format='{{ .NetworkSettings.Networks.sparrow.IPAddress }}' docker-sinatra
