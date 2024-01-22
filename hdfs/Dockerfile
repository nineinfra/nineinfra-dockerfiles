FROM eclipse-temurin:17-jdk-jammy

ENV HADOOP_VERSION	3.3.6
ENV HADOOP_HOME		/opt/hadoop
ENV HADOOP_OPTS		-Djava.library.path=$HADOOP_HOME/lib/native
ENV PATH		$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN sed -i s/deb.debian.org/mirrors.ustc.edu.cn/g /etc/apt/sources.list && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y netcat wget telnet net-tools curl vim inetutils-ping dnsutils libzip4 libsnappy1v5 libssl-dev && \
    wget https://mirrors.ustc.edu.cn/apache/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    rm -rf /var/lib/apt/lists/* && \
    tar -zxf /hadoop-$HADOOP_VERSION.tar.gz && \
    rm /hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    mkdir -p $HADOOP_HOME/logs

WORKDIR $HADOOP_HOME
COPY start-hdfs.sh $HADOOP_HOME/sbin/
COPY log4j.properties $HADOOP_HOME/conf/
COPY core-site.xml.default $HADOOP_HOME/conf/
COPY hdfs-site.xml.default $HADOOP_HOME/conf/

CMD ["$HADOOP_HOME/sbin/start-hdfs.sh"]
