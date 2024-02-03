FROM eclipse-temurin:17-jdk-jammy

ENV HADOOP_VERSION	3.3.6
ENV HADOOP_HOME		/opt/hadoop
ENV HADOOP_OPTS		-Djava.library.path=$HADOOP_HOME/lib/native
ENV PATH		$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN sed -i s/archive.ubuntu.com/mirrors.ustc.edu.cn/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.ustc.edu.cn/g /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y netcat wget telnet net-tools curl vim inetutils-ping dnsutils libzip4 libsnappy1v5 libssl-dev && \
    wget https://mirrors.ustc.edu.cn/apache/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    rm -rf /var/lib/apt/lists/* && \
    tar -zxf /hadoop-$HADOOP_VERSION.tar.gz && \
    rm /hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    mkdir -p $HADOOP_HOME/logs && \
    mkdir -p $HADOOP_HOME/temp

WORKDIR $HADOOP_HOME
COPY start-hdfs.sh $HADOOP_HOME/sbin/
COPY log4j.properties $HADOOP_HOME/etc/hadoop/
COPY httpfs-log4j.properties $HADOOP_HOME/etc/hadoop/
COPY hadoop-env.sh $HADOOP_HOME/etc/hadoop/
COPY httpfs-env.sh $HADOOP_HOME/etc/hadoop/
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HADOOP_LOG_DIR $HADOOP_HOME/logs

CMD ["sbin/start-hdfs.sh"]
