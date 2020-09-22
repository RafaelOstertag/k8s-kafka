FROM alpine:latest AS staging
ARG ZK_VERSION=3.6.2

ADD http://mirror.easyname.ch/apache/zookeeper/zookeeper-${ZK_VERSION}/apache-zookeeper-${ZK_VERSION}-bin.tar.gz /staging/zk.tar.gz
WORKDIR /staging
RUN tar xf zk.tar.gz && mv apache-zookeeper-${ZK_VERSION}-bin/* .


FROM openjdk:11-jre-slim
ARG ZK_USER=424242


RUN mkdir -p /zk/data && chown ${ZK_USER} /zk/data
ADD start.sh /
COPY --chown=${ZK_USER} log4j.properties standalone.cfg /zk/conf/

COPY --from=staging --chown=${ZK_USER} /staging/lib /zk/lib

WORKDIR /zk
VOLUME [ "/zk/data" ]

USER ${ZK_USER}

ENTRYPOINT ["/start.sh"]
