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
ARG java_image_tag=11-jre-slim
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
ARG MYSQL_CONNECT_JAVA=8.0.33

FROM openjdk:${java_image_tag}

# ARG spark_uid=185

# Before building the docker image, first build and make a Spark distribution following
# the instructions in http://spark.apache.org/docs/latest/building-spark.html.
# If this docker file is being used in the context of building your images from a Spark
# distribution, the docker build command should be invoked from the top level directory
# of the Spark distribution. E.g.:
# docker build -t spark:latest -f kubernetes/dockerfiles/spark/Dockerfile .

RUN set -ex && \
    sed -i s/deb.debian.org/mirrors.ustc.edu.cn/g /etc/apt/sources.list && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt install -y bash tini libc6 libpam-modules krb5-user libnss3 procps && \
    mkdir -p /opt/spark && \
    mkdir -p /opt/spark/examples && \
    mkdir -p /opt/spark/work-dir && \
    touch /opt/spark/RELEASE && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    rm -rf /var/cache/apt/*

COPY jars /opt/spark/jars
COPY bin /opt/spark/bin
COPY sbin /opt/spark/sbin
COPY kubernetes/dockerfiles/spark/entrypoint.sh /opt/
COPY kubernetes/dockerfiles/spark/decom.sh /opt/
COPY examples /opt/spark/examples
COPY kubernetes/tests /opt/spark/tests
COPY data /opt/spark/data

ENV SPARK_HOME /opt/spark

# Download aws module for Hadoop (support for s3a://)
RUN curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar \
    -o ${SPARK_HOME}/jars/hadoop-aws-${HADOOP_VERSION}.jar && \
    chmod -x ${SPARK_HOME}/jars/hadoop-aws-${HADOOP_VERSION}.jar

# Download aws sdk bundle containing all the needed S3 Classes for hadoop-aws. Must match version hadoop-aws was compiled against
RUN curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_JAVA_SDK_BUNDLE}/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar \
    -o ${SPARK_HOME}/jars/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar && \
    chmod -x ${SPARK_HOME}/jars/aws-java-sdk-bundle-${AWS_JAVA_SDK_BUNDLE}.jar \

RUN curl -L https://repo1.maven.org/maven2/org/apache/doris/spark-doris-connector-${SPARK_VERSION}_${SCALA_VERSION}/${DORIS_CONNECTOR_VERSION}/spark-doris-connector-${SPARK_DORIS_CONNECTOR_VERSION}.jar \
    -o ${SPARK_HOME}/jars/spark-doris-connector-${SPARK_DORIS_CONNECTOR_VERSION}.jar && \
    chmod -x ${SPARK_HOME}/jars/spark-doris-connector-${SPARK_DORIS_CONNECTOR_VERSION}.jar

RUN curl -L https://github.com/oap-project/gluten/releases/download/v${GLUTEN_VERSION}/gluten-velox-bundle-spark${GLUTEN_SPARK_VERSION}.jar \
    -o ${SPARK_HOME}/jars/gluten-velox-bundle-spark${GLUTEN_SPARK_VERSION}.jar && \
    chmod -x ${SPARK_HOME}/jars/gluten-velox-bundle-spark${GLUTEN_SPARK_VERSION}.jar

RUN curl -L https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.jar \
    -o ${KYUUBI_HOME}/jars/postgresql-${POSTGRESQL_VERSION}.jar && \
    chmod -x ${KYUUBI_HOME}/jars/postgresql-${POSTGRESQL_VERSION}.jar

# Download mysql connect java
RUN curl -L https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECT_JAVA}/mysql-connector-java-${MYSQL_CONNECT_JAVA}.jar \
    -o /opt/hive/lib/mysql-connector-java-${MYSQL_CONNECT_JAVA}.jar && \
    chmod -x /opt/hive/lib/mysql-connector-java-${MYSQL_CONNECT_JAVA}.jar

WORKDIR /opt/spark/work-dir
RUN chmod g+w /opt/spark/work-dir
RUN chmod a+x /opt/decom.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Specify the User that the actual main process will run as
# USER ${spark_uid}
