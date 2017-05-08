FROM centos:latest
MAINTAINER Izhar ul Hassan "ezhaar@gmail.com"

USER root

# export hadoop variables
ENV SPARK_HOME /usr/local/spark
ENV SPARK_CONF_DIR /usr/local/spark/conf

RUN yum update -y
RUN yum install -y java-1.8.0-openjdk-headless.x86_64
RUN yum clean all

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-2.b11.el7_3.x86_64/jre
# Download and extract spark-2.1.1
RUN curl -o /tmp/spark-2.1.1-bin-hadoop2.7.tgz http://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz \
   && tar -xzf /tmp/spark-2.1.1-bin-hadoop2.7.tgz -C /usr/local/ && rm -rf /tmp/*

RUN mv /usr/local/spark-2.1.1-bin-hadoop2.7 /usr/local/spark
RUN mv $SPARK_CONF_DIR/log4j.properties.template $SPARK_CONF_DIR/log4j.properties

ENV PATH $PATH:/usr/local/spark/bin:/usr/local/spark/sbin
ENV TERM xterm

CMD ["/bin/bash"]
