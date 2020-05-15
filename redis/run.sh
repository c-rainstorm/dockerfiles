#!/bin/bash

# ./run.sh --tag=5.0.9

function usage() {
    echo "./run.sh [-t[version]] [--tag=[version]] [options]"
    echo ""
    echo "[option]"
    echo ""
    echo "-t --tag=[value]      用于运行指定版本的 Redis"
    echo "-h --help             帮助文档"
    echo "                   "
    echo "[Example]          "
    echo "                   "
    echo "tag=5.0.9"
    echo "  ./run.sh --tag=5.0.9"
    echo "  ./run.sh -t5.0.9"
}

tag=""
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

if [ `docker images rainstorm/redis:${tag} -q |wc -l` -eq 0 ]; then
    echo "rainstorm/redis:${tag} 镜像不存在，请先使用 ./build.sh 构建"
    echo ""
    ./build.sh -h
    exit 0
fi

REDIS_PASS_FILE=~/.redis_password
echo "######################################################"
if [ ! -e ${REDIS_PASS_FILE} ] || [ `cat ${REDIS_PASS_FILE} | wc -l` -eq 0 ]; then
    openssl rand -base64 10 > ${REDIS_PASS_FILE}
    echo "new password generated, find it in ${REDIS_PASS_FILE}"
else
    echo "use password in ${REDIS_PASS_FILE} generated before"
fi
echo "######################################################"

if [ `docker container ls --filter=name=redis_${tag} -q | wc -l` -gt 0 ]; then
    echo "stopping container [redis_${tag}]"
    docker container stop redis_${tag}
    echo "done"
fi

if [ `docker container ls -a --filter=name=redis_${tag} -q | wc -l` -gt 0 ]; then
    echo "removing container [redis_${tag}]"
    docker container rm redis_${tag}
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

echo "starting container [redis_${tag}]"
docker run -d -P --name redis_${tag} rainstorm/redis:${tag}  redis-server ${REDIS_RUNTIME_CONFIG_FLAGS}
echo "done"

echo "binding local port: `docker port redis_${tag} | awk -F: '{print $NF}'`"
