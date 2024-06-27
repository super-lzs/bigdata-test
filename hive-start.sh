cd /opt/hive/lib/
rm -rf *disruptor*.jar
rm -rf *log4j*.jar


curl -O https://mirrors.tencent.com/repository/maven/tdmq/com/lmax/disruptor/3.4.2/disruptor-3.4.2.jar
curl -O https://mirrors.tencent.com/repository/maven/yuewen_qdnexus/org/apache/logging/log4j/log4j-jul/2.17.1/log4j-jul-2.17.1.jar
curl -O https://mirrors.tencent.com/repository/maven/yuewen_qdnexus/org/apache/logging/log4j/log4j-1.2-api/2.17.1/log4j-1.2-api-2.17.1.jar
curl -O https://mirrors.tencent.com/repository/maven/yuewen_qdnexus/org/apache/logging/log4j/log4j-slf4j-impl/2.17.1/log4j-slf4j-impl-2.17.1.jar
curl -O https://mirrors.tencent.com/repository/maven/yuewen_qdnexus_common/org/apache/logging/log4j/log4j-api/2.17.1/log4j-api-2.17.1.jar
curl -O https://mirrors.tencent.com/repository/maven/yuewen_qdnexus_common/org/apache/logging/log4j/log4j-core/2.17.1/log4j-core-2.17.1.jar
curl -O https://mirrors.tencent.com/repository/maven/yuewen_qdnexus/org/apache/logging/log4j/log4j-web/2.17.1/log4j-web-2.17.1.jar
chown root:staff *.jar

if [ $1 = "hive-metastore" ]; then
    /wait-for-it.sh -t 180 namenode:9000 -- /opt/hive/bin/hive --service metastore
else
    /wait-for-it.sh -t 180 namenode:9000 -- /usr/local/bin/startup.sh
fi

