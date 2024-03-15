FROM eclipse-temurin:17-jdk-jammy

ENV SEATUNNEL_VERSION="2.3.4"
ENV SPARK_VERSION="3.2.4"
ENV HADOOP_VERSION="3.2"
ENV SEATUNNEL_HOME="/opt/seatunnel"
ENV SPARK_HOME="/opt/spark"

COPY apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz .
COPY spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz .

RUN tar -zxvf apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz \
    && mv apache-seatunnel-${SEATUNNEL_VERSION} ${SEATUNNEL_HOME} \
    && rm -f apache-seatunnel-${SEATUNNEL_VERSION}-bin.tar.gz \
    && tar -zxvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} \
    && rm -f spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz 

WORKDIR $SEATUNNEL_HOME
CMD ["/bin/bash","-l"]
