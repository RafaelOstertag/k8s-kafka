#!/bin/sh

set -e

JAVA_OPTS="$JAVA_OPTS -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ExplicitGCInvokesConcurrent -XX:MaxInlineLevel=15 -Djava.awt.headless=true"
JAVA_OPTS="$JAVA_OPTS -Dlog4j.configuration=file:/kafka/conf/log4j.properties"
export JAVA_OPTS

exec /kafka/bin/kafka-run-class.sh \
    kafka.Kafka \
    /kafka/conf/server.properties
