#!/bin/bash

# ./build.sh --tag=1.8.0_191

# 华为云 JDK镜像 https://mirrors.huaweicloud.com/java/jdk/

function usage() {
    echo "./build.sh [option]"
    echo ""
    echo "[option]"
    echo ""
    echo "-t --tag=[value]   用于指定构建 JDK的tag"
    echo "                   不传默认使用不带后缀的文件名"
    echo "-h --help          帮助文档"
    echo "                   "
    echo "[Example]          "
    echo "                   "
    echo "tag=v1.8.0_191"
    echo "  ./build.sh --tag=v1.8.0_191"
    echo "  ./build.sh -tv1.8.0_191"
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

if [ `ls | grep jdk |wc -l` -gt 0 ]; then
    export ZIP_FILE=`ls | grep jdk`
    echo "jdk found: ${ZIP_FILE}"

    if [ ${#tag} -eq 0 ]; then
        tag=`echo ${ZIP_FILE} | awk -F. '{print $1}'`
    fi

    docker build --build-arg JDK_ZIP_FILE=${ZIP_FILE} -t=rainstorm/oracle-jdk:${tag} .
else
    echo "jdk 不存在，可以到 https://mirrors.huaweicloud.com/java/jdk/ 下载"
fi
