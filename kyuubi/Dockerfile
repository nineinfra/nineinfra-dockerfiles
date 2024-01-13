#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Usage:
#   1. use ./build/dist to make binary distributions of Kyuubi or download a release
#   2. Untar it and run the docker command below
#      docker build -f docker/Dockerfile -t repository/kyuubi:tagname .
#   Options:
#     -f this docker file
#     -t the target repo and tag name
#     more options can be found with -h

ARG BASE_IMAGE=eclipse-temurin:8-jdk-focal
ARG spark_provided="spark_builtin"

FROM ${BASE_IMAGE} as builder_spark_provided
ONBUILD ARG spark_home_in_docker
ONBUILD ENV SPARK_HOME ${spark_home_in_docker}

FROM ${BASE_IMAGE} as builder_spark_builtin

ONBUILD ENV SPARK_HOME /opt/spark
ONBUILD RUN mkdir -p ${SPARK_HOME}
ONBUILD COPY spark-binary ${SPARK_HOME}

FROM builder_${spark_provided}

ARG kyuubi_uid=10009
USER root

ENV KYUUBI_HOME /opt/kyuubi
ENV KYUUBI_LOG_DIR ${KYUUBI_HOME}/logs
ENV KYUUBI_PID_DIR ${KYUUBI_HOME}/pid
ENV KYUUBI_WORK_DIR_ROOT ${KYUUBI_HOME}/work

ARG METASTORE_VERSION=3.1.3
ARG HADOOP_VERSION=3.3.1
ARG AWS_JAVA_SDK_BUNDLE=1.12.560
ARG SPARK_VERSION=3.2
ARG SCALA_VERSION=2.12
ARG DORIS_CONNECTOR_VERSION=1.3.0
ARG GLUTEN_VERSION=1.1.0
ARG SPARK_DORIS_CONNECTOR_VERSION=${SPARK_VERSION}_${SCALA_VERSION}-${DORIS_CONNECTOR_VERSION}
ARG GLUTEN_SPARK_VERSION=${SPARK_VERSION}_${SCALA_VERSION}-${GLUTEN_VERSION}
ARG POSTGRESQL_VERSION=42.7.1
ARG NINEINFRA_DOWNLOAD_VERSION=0.4.5
ARG KYUUBI_VERSION=1.8.0
ARG MYSQL_CONNECT_JAVA=8.0.33

RUN set -ex && \
    sed -i 's/http:\/\/deb.\(.*\)/https:\/\/deb.\1/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y bash tini libc6 libpam-modules krb5-user libnss3 procps && \
    ln -snf /bin/bash /bin/sh && \
    useradd -u ${kyuubi_uid} -g root kyuubi -d /home/kyuubi -m && \
    mkdir -p ${KYUUBI_HOME} ${KYUUBI_LOG_DIR} ${KYUUBI_PID_DIR} ${KYUUBI_WORK_DIR_ROOT} && \
    rm -rf /var/cache/apt/*

COPY LICENSE NOTICE RELEASE ${KYUUBI_HOME}/
COPY bin ${KYUUBI_HOME}/bin
COPY jars ${KYUUBI_HOME}/jars
COPY beeline-jars ${KYUUBI_HOME}/beeline-jars
COPY web-ui ${KYUUBI_HOME}/web-ui
COPY externals/engines/spark ${KYUUBI_HOME}/externals/engines/spark

# Download aws module for Hadoop (support for s3a://)
RUN curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar \
    -o ${KYUUBI_HOME}/jars/hadoop-aws-${HADOOP_VERSION}.jar && \
    chmod -x ${KYUUBI_HOME}/jars/hadoop-aws-${HADOOP_VERSION}.jar

# Download aws sdk bundle containing all the needed S3 Classes for hadoop-aws. Must match version hadoop-aws was compiled against
RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_JAVA_SDK_BUNDLE}/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar \
    -o ${KYUUBI_HOME}/jars/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar && \
    chmod -x ${KYUUBI_HOME}/jars/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar \

RUN curl -L https://repo1.maven.org/maven2/org/apache/doris/spark-doris-connector-${SPARK_VERSION}_${SCALA_VERSION}/${DORIS_CONNECTOR_VERSION}/spark-doris-connector-${SPARK_DORIS_CONNECTOR_VERSION}.jar \
    -o ${KYUUBI_HOME}/jars/spark-doris-connector-${SPARK_DORIS_CONNECTOR_VERSION}.jar && \
    chmod -x ${KYUUBI_HOME}/jars/spark-doris-connector-${SPARK_DORIS_CONNECTOR_VERSION}.jar

RUN curl -L https://github.com/oap-project/gluten/releases/download/v${GLUTEN_VERSION}/gluten-velox-bundle-spark${GLUTEN_SPARK_VERSION}.jar \
    -o ${KYUUBI_HOME}/jars/gluten-velox-bundle-spark${GLUTEN_SPARK_VERSION}.jar && \
    chmod -x ${KYUUBI_HOME}/jars/gluten-velox-bundle-spark${GLUTEN_SPARK_VERSION}.jar

RUN curl -L https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.jar \
    -o ${KYUUBI_HOME}/jars/postgresql-${POSTGRESQL_VERSION}.jar && \
    chmod -x ${KYUUBI_HOME}/jars/postgresql-${POSTGRESQL_VERSION}.jar

RUN curl -L https://github.com/nineinfra/nineinfra/releases/download/v${NINEINFRA_DOWNLOAD_VERSION}/kyuubi-tpcds_${SCALA_VERSION}-${KYUUBI_VERSION}.jar \
    -o ${KYUUBI_HOME}/jars/kyuubi-tpcds_${SCALA_VERSION}-${KYUUBI_VERSION}.jar && \
    chmod -x ${KYUUBI_HOME}/jars/kyuubi-tpcds_${SCALA_VERSION}-${KYUUBI_VERSION}.jar

# Download mysql connect java
RUN curl -L https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECT_JAVA}/mysql-connector-java-${MYSQL_CONNECT_JAVA}.jar \
    -o /opt/hive/lib/mysql-connector-java-${MYSQL_CONNECT_JAVA}.jar && \
    chmod -x /opt/hive/lib/mysql-connector-java-${MYSQL_CONNECT_JAVA}.jar

WORKDIR ${KYUUBI_HOME}
RUN chown -R kyuubi:root ${KYUUBI_HOME} && \
    chmod ug+rw -R ${KYUUBI_HOME} && \
    chmod a+rwx -R ${KYUUBI_WORK_DIR_ROOT}

CMD [ "./bin/kyuubi", "run" ]

USER ${kyuubi_uid}
