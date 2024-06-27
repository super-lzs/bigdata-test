0. 前言
    使用docker-compose在本地一键部署一个简单的大数据环境, 用于对大数据计算的工作流有一个简单的理解
    使用到的组件:
        a. hadoop-hdfs, namenode datanode
        b. hadoop-hive, hive hive-metastore
        c. spark, master work0 work1
    spark job:
        检索出输入文件(在hdfs中)中各个单词出现的次数，并写到hive中

1. 环境依赖安装（我以centos为例）:
    a. yum install -y docker-compose

2. 物料说明
    ├── core-site.xml         // 用于指定Hadoop集群的各种参数，例如HDFS的默认文件系统、YARN的资源管理器地址等
    ├── docker-compose.yml    // docker-compose文件, 拉取镜像并完成部署
    ├── hdfs-site.xml         // 用于指定HDFS的各种参数，例如副本数、数据块大小、NameNode和DataNode的存储路径等
    ├── hdfs-start.sh         // 包含了启动NameNode和DataNode的命令
    ├── hive-site.xml         // Hive的配置文件，用于指定Hive的各种参数，例如元数据存储的位置、数据仓库的位置等
    ├── hive-start.sh         // 启动Hive的脚本文件
    ├── input.txt
    ├── readme.md
    ├── spark-master.sh       // 启动Spark的脚本文件，其中包含了启动Spark Master和Worker的命令
    ├── spark.properties      // Spark的配置文件，用于指定Spark的各种参数，例如内存分配、任务调度
    ├── wait-for-it.sh        // 用于等待某个服务启动完成的脚本文件，例如在启动Hadoop集群时，需要等待NameNode和DataNode都启动完成后再启动其他服务
    └── wordcount.py          // spark job

3. 执行步骤
    a. 启动服务, docker-compose up -d
    b. 准备测试数据
        b1. docker cp input.txt namenode:/
        b2. docker exec -it namenode bash
        b3. hdfs dfs -put /input.txt /tmp/input.txt
        b4. hdfs dfs -ls /tmp
    c. 创建hive表
        c1. docker exec -it hive bash
        c2. hive -e "CREATE DATABASE my_db"
        c3. hive -e "CREATE TABLE test (word STRING, count INT)
                ROW FORMAT DELIMITED
                FIELDS TERMINATED BY ','
                STORED AS TEXTFILE;"
        c4. hive -e "use my_db; show tables;"
    d. 提交job
        d1. docker cp wordcount.py spark-master:/
        d2. docker exec -it spark-master bash
        d3. /spark/bin/spark-submit --master spark://spark-master:7077 /wordcount.py hdfs://namenode:9000/tmp/input.txt hdfs://namenode:9000/tmp/output.txt
    e. 查看结果
        e1. hdfs dfs -cat /tmp/output.txt/*
        e2. hive -e "use my_db; select * from test;"
    f. 清理环境, docker-compose down

