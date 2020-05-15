#!/bin/bash

# ./build.sh --tag=5.0.9
# ./build.sh --tag=5.0.9 --http-proxy=http://localhost:1087

function usage() {
    echo "./build.sh [-t[version]] [--tag=[version]] [options]"
    echo ""
    echo "[option]"
    echo ""
    echo "-t --tag=[value]      用于指定构建 Redis 的版本"
    echo "--http-proxy=[value]  使用的代理，详细文档见 curl man page"
    echo "--https-proxy=[value] 使用的代理，详细文档见 curl man page"
    echo "-h --help             帮助文档"
    echo "                   "
    echo "[Example]          "
    echo "                   "
    echo "tag=5.0.9"
    echo "  ./build.sh --tag=5.0.9"
    echo "  ./build.sh -t5.0.9"
    echo "  ./build.sh --tag=5.0.9 --http-proxy=localhost:1087"
}

tag=""
http_proxy=""
https_proxy=""
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
                http-proxy=*)
                    http_proxy=${OPTARG#*=}
                    ;;
                https-proxy=*)
                    https_proxy=${OPTARG#*=}
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

redis_zip_file="redis-${tag}.tar.gz"
if [ -f "${redis_zip_file}" ]; then
    echo "$redis_zip_file exist"
else
    echo "curl `if [ ${#http_proxy} -gt 0 ]; then echo "--proxy ${http_proxy}"; fi` http://download.redis.io/releases/redis-${tag}.tar.gz"
    curl `if [ ${#http_proxy} -gt 0 ]; then echo "--proxy ${http_proxy}"; fi` http://download.redis.io/releases/redis-${tag}.tar.gz -o redis-${tag}.tar.gz
fi

docker build --build-arg REDIS_VERSION=${tag} -t=rainstorm/redis:${tag} .
