#!/bin/bash

# ./build.sh --https-proxy=http://localhost:1087

function usage() {
    echo "./build.sh [options]"
    echo ""
    echo "[option]"
    echo ""
    echo "--https-proxy=[value] 使用的代理，详细文档见 curl man page"
    echo "-h --help             帮助文档"
    echo "                   "
    echo "[Example]          "
    echo "                   "
    echo "  ./build.sh --https-proxy=localhost:1087"

}

https_proxy=""
while getopts t:h-: opt;do
    case $opt in
        -)
            case $OPTARG in
                help)
                    usage
                    exit 0
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

if [ ${#https_proxy} -gt 0 ]; then
    echo "构建启用HTTPS代理"
    echo ""
    echo "暂存 HTTPS_PROXY 环境变量 [${HTTPS_PROXY}]"
    old_https_proxy=${HTTPS_PROXY}
    echo "配置 docker pull HTTPS_PROXY 环境变量 [${https_proxy}]"
    export HTTPS_PROXY=${https_proxy}

    docker build -t=rainstorm/custom-centos:7 .

    echo "重置 HTTPS_PROXY 环境变量 [${old_https_proxy}]"
    export HTTPS_PROXY=${old_https_proxy}

    exit 0;
fi

echo "构建不启用HTTPS代理"

docker build -t=rainstorm/custom-centos:7 .
