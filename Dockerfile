# Build hadoo-base image on Ubuntu 14.04.1

FROM ezhaar/hadoop-2.4.0
MAINTAINER Izhar ul Hassan "ezhaar@gmail.com"

USER root

# Setup a tmp volume for downloads
VOLUME ["/tmp"]


# export hadoop variables
ENV SPARK_HOME /usr/local/spark
ENV SPARK_CONF_DIR /usr/local/spark/conf

# Download and extract hadoop-2.4.0 compiled by ezhaar on x86_64
RUN /usr/bin/wget \
  http://d3kbcqa49mib13.cloudfront.net/spark-1.2.0-bin-hadoop2.4.tgz \
  -P /tmp && tar -xzf /tmp/spark-1.2.0-bin-hadoop2.4.tgz -C /usr/local/ && rm -rf /tmp/*

RUN ln -s /usr/local/spark-1.2.0-bin-hadoop2.4 /usr/local/spark
RUN mv $SPARK_CONF_DIR/log4j.properties.template $SPARK_CONF_DIR/log4j.properties
RUN cp $HADOOP_CONF_DIR/slaves $SPARK_HOME/conf/

ENV PATH $PATH:/usr/local/spark/bin:/usr/local/spark/sbin
COPY spark_conf/spark-env.sh $SPARK_CONF_DIR/

# Define default command.
CMD ["bash"]
