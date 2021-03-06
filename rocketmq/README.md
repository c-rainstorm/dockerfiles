# RocketMQ 集群快速搭建

## 脚本能够支持的集群类型

- 任意数量的 name server
- N主N*M从broker集群

## 构建镜像

```bash
./build.sh
```

## 启动集群

```bash
./run.sh
```

默认情况下，运行完毕没有任何错误的情况下，会启动一个 3NameServer，2主2从 Broker集群，1Console，脚本会自动在浏览器内打开 Console 的控制页面。

## 自定义集群

`config.sh` 中定义了脚本中可以自定义的配置

```bash
# rocketmq 镜像
ROCKETMQ_NS_IMAGE=${DOCKER_REPOSITORY_NAMESPACE}/rocketmq-ns:4.7.0
ROCKETMQ_BROKER_IMAGE=${DOCKER_REPOSITORY_NAMESPACE}/rocketmq-broker:4.7.0

# 网络，docker 网络，若当前没有，会自动创建
NETWORK=sparrow

# nameServer 配置
## 容器数量
NAME_SERVER_NUM=3
##容器名前缀，后缀为 1 到 NAME_SERVER_NUM 的整数
NAME_SERVER_CONTAINER_NAME_PREFIX=namesrv-

## Broker 配置
# 目前只支持 N主N*M从
# 同步模式只支持异步刷盘，主从同步写
## 主容器数量
MASTER_NUM=3
## 每个主容器支持的从节点数量，看你的机器配置，因为从节点需要的 JVM 空间较多，所以单机一般开不了太多，如果太多，新容器会被直接 kill 掉
## 堆容量默认是 8G，本地根本跑不起来，所以手动将堆容量调整为 512m了，详细JVM配置见 broker/runBroker.sh，这个配置直接打到 broker 的镜像里了
SLAVE_NUM_EACH_MASTER=1
## broker集群名称
BROKER_CLUSTER_NAME=DefaultCluster
## broker名前缀
## 主节点容器名后缀为 ${BROKER_NAME_PREFIX}[1-MASTER_NUM]-master
## 从节点容器名后缀为 ${BROKER_NAME_PREFIX}[1-MASTER_NUM]-slave-[1-SLAVE_NUM_EACH_MASTER]
BROKER_NAME_PREFIX="${BROKER_CLUSTER_NAME}-broker-"

## RocketMQ console
### 启用UI控制台
ROCKETMQ_CONSOLE_ENABLE=1
### 控制台容器名
ROCKETMQ_CONSOLE_CONTAINER_NAME=rocketmq-console
```

## 主机端口映射

默认情况下，NameServer 和 Broker不向宿主机暴露端口，仅在 Docker 内网中可访问，用户通过 Console 操作 MQ 集群。

## 深度定制

多主多从部署架构是生产级别的部署架构，正常情况测试使用直接用这个就可以了，如果不能满足需要，可以参考这个配置进行自行定义。
