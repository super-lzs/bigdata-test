rm -rf $JAVA_HOME
mkdir -p /usr/lib/jvm/
cd /usr/lib/jvm/
wget https://mirrors.tencent.com/repository/generic/konajdk/8/0/14/linux-x86_64/b1/TencentKona8.0.14.b1_jdk_linux-x86_64_8u372.tar.gz
tar xzvf TencentKona8.0.14.b1_jdk_linux-x86_64_8u372.tar.gz

export JAVA_HOME=/usr/lib/jvm/TencentKona-8.0.14-372/
export PATH=${JAVA_HOME}/bin:$PATH
echo "export JAVA_HOME=/usr/lib/jvm/TencentKona-8.0.14-372/"  >> ~/.bashrc
echo "export PATH=/usr/lib/jvm/TencentKona-8.0.14-372/bin:$PATH" >> ~/.bashrc
if [ $1 = "namenode" ]; then
    if [ ! -d "/var/hadoop/dfs/name" ]; then
        $HADOOP_HOME/bin/hdfs namenode -format
    fi
fi

$HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start $1

if [ $1 = "datanode" ]; then
    /wait-for-it.sh -t 180 namenode:9000
    hadoop fs -mkdir -p    /spark-history
    hadoop fs -chmod g+w   /spark-history
fi

tail -f /dev/null
