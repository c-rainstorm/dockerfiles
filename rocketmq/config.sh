source ../setenv.sh

# rocketmq 镜像
ROCKETMQ_NS_IMAGE=${DOCKER_REPOSITORY}/rocketmq-ns:4.7.0
ROCKETMQ_BROKER_IMAGE=${DOCKER_REPOSITORY}/rocketmq-broker:4.7.0

# 网络
NETWORK=sparrow

# nameServer 配置
NAME_SERVER_NUM=3
NAME_SERVER_CONTAINER_NAME_PREFIX=namesrv-

## Broker 配置
# 目前只支持 N主N*M从
# 同步模式只支持异步刷盘，主从同步写
MASTER_NUM=3
SLAVE_NUM_EACH_MASTER=1
BROKER_CLUSTER_NAME=DefaultCluster
BROKER_NAME_PREFIX="${BROKER_CLUSTER_NAME}-broker-"
