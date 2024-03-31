FROM eclipse-temurin:17-jdk-jammy

ENV SEATUNNEL_VERSION="2.3.4"
ENV SPARK_VERSION="3.2.4"
ENV HADOOP_VERSION="3.2"
ENV SEATUNNEL_HOME="/opt/seatunnel"
ENV SPARK_HOME="/opt/spark"
ARG AWS_JAVA_SDK_BUNDLE=1.12.560
ARG HADOOP_AWS_VERSION=3.3.1

COPY apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz .
COPY spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz .

RUN sed -i s/archive.ubuntu.com/mirrors.ustc.edu.cn/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.ustc.edu.cn/g /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y netcat wget telnet net-tools curl vim inetutils-ping dnsutils libzip4 libsnappy1v5 libssl-dev && \
    tar -zxvf apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz && \
    mv apache-seatunnel-${SEATUNNEL_VERSION} ${SEATUNNEL_HOME} && \
    rm -f apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz && \
    tar -zxvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} && \
    rm -f spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_JAVA_SDK_BUNDLE}/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar \
        -o ${SPARK_HOME}/jars/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar  && \
    chmod -x ${SPARK_HOME}/jars/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar && \
    curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_AWS_VERSION}/hadoop-aws-${HADOOP_AWS_VERSION}.jar \
        -o ${SPARK_HOME}/jars/hadoop-aws-${HADOOP_AWS_VERSION}.jar && \
    chmod -x ${SPARK_HOME}/jars/hadoop-aws-${HADOOP_AWS_VERSION}.jar &&\
    mkdir -p ${SEATUNNEL_HOME}/logs

WORKDIR $SEATUNNEL_HOME
CMD ["/bin/bash","-l"]
