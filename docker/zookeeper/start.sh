#!/bin/sh

set -e

CLASSPATH="/zk/conf:$CLASSPATH"

for i in /zk/lib/*.jar
do
    CLASSPATH="$i:$CLASSPATH"
done

exec /usr/local/openjdk-11/bin/java \
    -XX:OnOutOfMemoryError='kill -9 %p' \
    -cp "$CLASSPATH" org.apache.zookeeper.server.quorum.QuorumPeerMain /zk/conf/standalone.cfg
