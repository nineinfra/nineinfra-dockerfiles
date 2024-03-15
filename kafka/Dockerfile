FROM eclipse-temurin:11-jre-jammy

ARG KAFKA_VERSION=3.7.0
ARG SCALA_VERSION=2.13
ENV KAFKA_HOME=/opt/kafka

RUN sed -i s/deb.debian.org/mirrors.ustc.edu.cn/g /etc/apt/sources.list && \
    sed -i s/archive.ubuntu.com/mirrors.ustc.edu.cn/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.ustc.edu.cn/g /etc/apt/sources.list && \
    apt update && apt install -y netcat vim iputils-ping net-tools telnet && apt upgrade -y

RUN curl -sLO https://mirrors.ustc.edu.cn/apache/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar xvfz kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    mv kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} && \
    rm -rf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

ENV LOG_DIR=${KAFKA_HOME}/logs

COPY ./kafkaStart.sh ${KAFKA_HOME}/bin/kafkaStart.sh
RUN chmod +x ${KAFKA_HOME}/bin/kafkaStart.sh

WORKDIR ${KAFKA_HOME}

ENTRYPOINT ["/opt/kafka/bin/kafkaStart.sh"]
