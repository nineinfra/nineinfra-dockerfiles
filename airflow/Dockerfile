# https://airflow.apache.org/docs/docker-stack/build.html#build-build-image
FROM apache/airflow:2.7.3
USER root
RUN sed -i s/deb.debian.org/mirrors.ustc.edu.cn/g /etc/apt/sources.list
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         vim \
         heimdal-dev openjdk-11-jdk build-essential libopenmpi-dev openssh-server openssh-client libsasl2-dev\
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
# https://airflow.apache.org/docs/
USER airflow
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple apache-airflow-providers-apache-spark \
    apache-airflow-providers-apache-flink apache-airflow-providers-apache-hdfs apache-airflow-providers-apache-hive \
    apache-airflow-providers-apache-kafka apache-airflow-providers-apache-kylin apache-airflow-providers-apache-cassandra \
    apache-airflow-providers-apache-druid apache-airflow-providers-apache-livy apache-airflow-providers-apache-pig \
    apache-airflow-providers-apache-drill apache-airflow-providers-apache-pinot apache-airflow-providers-apache-sqoop  \
    apache-airflow-providers-mongo apache-airflow-providers-neo4j apache-airflow-providers-presto \
    apache-airflow-providers-trino apache-airflow-providers-alibaba apache-airflow-providers-dingding \
    apache-airflow-providers-vertica
