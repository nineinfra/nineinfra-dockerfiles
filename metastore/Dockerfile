FROM openjdk:8-jdk-slim

ARG METASTORE_VERSION=3.1.3
ARG HADOOP_VERSION=3.3.1
ARG AWS_JAVA_SDK_BUNDLE=1.12.560
ARG MYSQL_CONNECT_JAVA=8.0.33

WORKDIR /opt

# Download hive and hadoop
RUN curl -L https://mirrors.ustc.edu.cn/apache/hive/hive-${METASTORE_VERSION}/apache-hive-${METASTORE_VERSION}-bin.tar.gz | tar -xzC . && \
    ln -s /opt/apache-hive-${METASTORE_VERSION}-bin /opt/hive

RUN curl -L https://mirrors.ustc.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar -xzC . && \
    ln -s /opt/hadoop-${HADOOP_VERSION} /opt/hadoop

# Download mysql connect java
RUN curl -L https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECT_JAVA}/mysql-connector-java-${MYSQL_CONNECT_JAVA}.jar \
    -o /opt/hive/lib/mysql-connector-java-${MYSQL_CONNECT_JAVA}.jar && \
    chmod -x /opt/hive/lib/mysql-connector-java-${MYSQL_CONNECT_JAVA}.jar

# Download aws module for Hadoop (support for s3a://)
RUN curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar \
    -o /opt/hive/lib/hadoop-aws-${HADOOP_VERSION}.jar && \
    chmod -x /opt/hive/lib/hadoop-aws-${HADOOP_VERSION}.jar

# Download aws sdk bundle containing all the needed S3 Classes for hadoop-aws. Must match version hadoop-aws was compiled against
RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_JAVA_SDK_BUNDLE}/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar \
    -o /opt/hive/lib/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar && \
    chmod -x /opt/hive/lib/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar

ENV HADOOP_HOME=/opt/hadoop
ENV HIVE_HOME=/opt/hive

COPY entrypoint.sh .

RUN set -ex \
    && groupadd -r hive --gid=1000 \
    && useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive \
    && chown hive:hive -R ${HIVE_HOME} \
    && chown hive:hive entrypoint.sh \
    && chmod +x entrypoint.sh

USER hive
EXPOSE 9083

CMD ["sh", "entrypoint.sh"]
