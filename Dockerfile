# Build hadoo-base image on Ubuntu 14.04.1

FROM ezhaar/docker-scala
MAINTAINER Izhar ul Hassan "ezhaar@gmail.com"

USER root

# Setup a tmp volume for downloads
VOLUME ["/tmp"]

COPY spark_conf/ssh_config /etc/ssh/

# export hadoop variables
ENV SPARK_HOME /usr/local/spark
ENV SPARK_CONF_DIR /usr/local/spark/conf

# Download and extract hadoop-2.4.0 compiled by ezhaar on x86_64
RUN /usr/bin/wget \
  http://d3kbcqa49mib13.cloudfront.net/spark-1.2.0-bin-hadoop2.4.tgz \
  -P /tmp && tar -xzf /tmp/spark-1.2.0-bin-hadoop2.4.tgz -C /usr/local/ && rm -rf /tmp/*

RUN mv /usr/local/spark-1.2.0-bin-hadoop2.4 /usr/local/spark
RUN mv $SPARK_CONF_DIR/log4j.properties.template $SPARK_CONF_DIR/log4j.properties
RUN cp $HADOOP_CONF_DIR/slaves $SPARK_HOME/conf/

ENV PATH $PATH:/usr/local/spark/bin:/usr/local/spark/sbin
COPY spark_conf/spark-env.sh $SPARK_CONF_DIR/

RUN apt-get update && apt-get install -y supervisor
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY spark_conf/start-bdas.sh /root/
COPY spark_conf/core-site.xml $HADOOP_CONF_DIR/
COPY spark_conf/yarn-site.xml $HADOOP_CONF_DIR/
ENV TERM xterm
VOLUME /usr/local/spark/conf
VOLUME /usr/local/hadoop-2.4.0/etc/hadoop
# Define default command.
CMD ["/usr/bin/supervisord"]
