FROM eclipse-temurin:11-jre-jammy

ARG ZOOKEEPER_VERSION=3.8.3

RUN sed -i s/deb.debian.org/mirrors.ustc.edu.cn/g /etc/apt/sources.list
RUN apt update && apt install -y netcat && apt upgrade -y

RUN curl -sLO https://mirrors.ustc.edu.cn/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz && \
    tar xvfz apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz && \
    mv apache-zookeeper-${ZOOKEEPER_VERSION}-bin /opt/zookeeper && \
    rm -rf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz

ENV ZOOKEEPER_HOME=/opt/zookeeper

COPY ./zkStart.sh $ZOOKEEPER_HOME/bin/zkStart.sh

WORKDIR /opt/zookeeper

ENTRYPOINT ["/opt/zookeeper/bin/zkStart.sh"]
