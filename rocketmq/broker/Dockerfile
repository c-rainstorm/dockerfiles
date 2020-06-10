FROM rainstorm/rocketmq:4.7.0

# expose broker ports
EXPOSE 10909 10911 10912

# 因为默认配置堆太大，导致 启动时直接被 kill 掉，此处调小申请的堆容量
COPY runBroker.sh /home/rocketmq/rocketmq-4.7.0/bin/runbroker.sh

CMD [ "./mqbroker", "-c", "/opt/rocketmq-4.7.0/conf/broker.conf" ]
