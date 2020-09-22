FROM alpine:latest AS staging
ARG KAFKA_VERSION=2.6.0

ADD http://mirror.easyname.ch/apache/kafka/${KAFKA_VERSION}/kafka_2.13-${KAFKA_VERSION}.tgz /staging/kafka.tar.gz
WORKDIR /staging
RUN tar xf kafka.tar.gz && mv kafka_2.13-${KAFKA_VERSION}/* .


FROM openjdk:11-jre-slim
ARG KAFKA_USER=424242

RUN mkdir -p /kafka/data && chown ${KAFKA_USER} /kafka/data
ADD kafka-run-class.sh /kafka/bin/
ADD start.sh /

COPY --chown=${KAFKA_USER} log4j.properties server.properties /kafka/conf/
COPY --from=staging --chown=${KAFKA_USER} /staging/libs /kafka/libs
COPY --from=staging --chown=${KAFKA_USER} \
    /staging/bin/kafka-acls.sh \
    /staging/bin/kafka-configs.sh \
    /staging/bin/kafka-console-consumer.sh \
    /staging/bin/kafka-console-producer.sh \
    /staging/bin/kafka-consumer-groups.sh \
    /staging/bin/kafka-delete-records.sh \
    /staging/bin/kafka-dump-log.sh \
    /staging/bin/kafka-leader-election.sh \
    /staging/bin/kafka-log-dirs.sh \
    /staging/bin/kafka-topics.sh \
    /kafka/bin/

WORKDIR /kafka
VOLUME [ "/kakfa/data" ]

USER ${KAFKA_USER}

ENTRYPOINT ["/start.sh"]
