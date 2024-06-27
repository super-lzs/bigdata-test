/wait-for-it.sh -t 180 namenode:9000
mkdir -p /spark/logs/
export SPARK_HISTORY_OPTS="-Dspark.history.fs.logDirectory=hdfs://namenode:9000/spark-history" 
sleep 5
nohup /bin/bash /spark/bin/spark-class org.apache.spark.deploy.history.HistoryServer >> /spark/logs/spark-history.out 2>&1 < /dev/null &

/bin/bash /master.sh
