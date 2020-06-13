#/bin/bash

source config.sh
source ${DOCKERFILES_ROOT}/tools.sh

createNetwork ${NETWORK}

function startNameServer(){
    CONTAINER_NAME=$1
    stopContainer ${CONTAINER_NAME}
    echo "Starting name server [${CONTAINER_NAME}]"
    docker run -d --network=${NETWORK} --name=${CONTAINER_NAME} ${ROCKETMQ_NS_IMAGE}
    echo "done"
}

# 镜像内部决定，不可配置
NAME_SERVER_PORT=9876
NSLIST=""

i=1
while(( ${i}<=${NAME_SERVER_NUM} ))
do
    if [ ${#NSLIST} -gt 0 ]; then
        NSLIST="${NSLIST};";
    fi

    startNameServer ${NAME_SERVER_CONTAINER_NAME_PREFIX}${i}
    NSLIST="$NSLIST${NAME_SERVER_CONTAINER_NAME_PREFIX}${i}:${NAME_SERVER_PORT}"
    let "i++"
done

# 可以自定义，但没什么必要
LOCAL_BROKER_CONFIG_DIR=`pwd`/config

mkdir -p ${LOCAL_BROKER_CONFIG_DIR}

function generateMasterConfig(){
    CONFIG_FILE=$1
    CLUSTER=$2
    BROKER_NAME=$3

    echo "brokerClusterName = ${CLUSTER}" > ${CONFIG_FILE}
    echo "brokerName = ${BROKER_NAME}" >> ${CONFIG_FILE}
    echo "brokerId = 0"  >> ${CONFIG_FILE}
    echo "brokerRole = SYNC_MASTER"  >> ${CONFIG_FILE}
    echo "flushDiskType = ASYNC_FLUSH"  >> ${CONFIG_FILE}
}

function generateSlaveConfig() {
    CONFIG_FILE=$1
    CLUSTER=$2
    BROKER_NAME=$3
    INDEX=$4

    echo "brokerClusterName = ${CLUSTER}" > ${CONFIG_FILE}
    echo "brokerName = ${BROKER_NAME}" >> ${CONFIG_FILE}
    echo "brokerId = ${INDEX}"  >> ${CONFIG_FILE}
    echo "brokerRole = SLAVE"  >> ${CONFIG_FILE}
    echo "flushDiskType = ASYNC_FLUSH"  >> ${CONFIG_FILE}
}

function startBroker() {
    CONFIG_FILE=$1
    NS=$2
    CONTAINER_NAME=${3}

    stopContainer ${CONTAINER_NAME}
    echo "Starting broker [${CONTAINER_NAME}]"
    docker run -d --network=${NETWORK} \
        --env NAMESRV_ADDR=${NS} \
        --volume ${CONFIG_FILE}:/opt/rocketmq-4.7.0/conf/broker.conf \
        --name=${CONTAINER_NAME} ${ROCKETMQ_BROKER_IMAGE}
    echo "done"
}

function startBrokerSet(){
    NS=$1
    BROKER_CLUSTER=$2
    INDEX=$3
    BROKER_NAME=${BROKER_NAME_PREFIX}${INDEX}

    generateMasterConfig ${LOCAL_BROKER_CONFIG_DIR}/${BROKER_NAME}-m.conf ${BROKER_CLUSTER} ${BROKER_NAME}
    startBroker ${LOCAL_BROKER_CONFIG_DIR}/${BROKER_NAME}-m.conf ${NS} ${BROKER_NAME}-master

    cur=1
    while(( ${cur}<=${SLAVE_NUM_EACH_MASTER} ))
    do
        SLAVE_CONFIG=${LOCAL_BROKER_CONFIG_DIR}/${BROKER_NAME}-s-${cur}.conf
        generateSlaveConfig ${SLAVE_CONFIG} ${BROKER_CLUSTER} ${BROKER_NAME} ${cur}
        startBroker ${SLAVE_CONFIG} ${NS} ${BROKER_NAME}-slave-${cur}
        let "cur++"
    done
}

i=1
while(( ${i}<=${MASTER_NUM} ))
do
    startBrokerSet ${NSLIST} ${BROKER_CLUSTER_NAME} ${i}
    let "i++"
done

CONSOLE_IMAGE_NAME=styletang/rocketmq-console-ng

stopContainer ${ROCKETMQ_CONSOLE_CONTAINER_NAME}

if [ ${ROCKETMQ_CONSOLE_ENABLE} -gt 0 ]; then
    echo "Starting rocketmq console"

    ensureImageExsit ${CONSOLE_IMAGE_NAME}
    stopContainer ${ROCKETMQ_CONSOLE_CONTAINER_NAME}

    docker run -d --name ${ROCKETMQ_CONSOLE_CONTAINER_NAME} \
        -p ${ROCKETMQ_CONSOLE_HOST_PORT}:8080 \
        --network=${NETWORK} \
        -e "JAVA_OPTS=-Drocketmq.namesrv.addr=${NSLIST} -Dcom.rocketmq.sendMessageWithVIPChannel=false" \
        ${CONSOLE_IMAGE_NAME}
    if [ $? -eq 0 ]; then
        echo "try to open http://localhost:${ROCKETMQ_CONSOLE_HOST_PORT}/ in brower"
        openUrlInBrowser http://localhost:${ROCKETMQ_CONSOLE_HOST_PORT}/
    fi

    echo "done"
fi

