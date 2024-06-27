# -*- coding: utf-8 -*-

import sys
from pyspark.sql import SparkSession
from pyspark import SparkConf, SparkContext
from pyspark.sql.functions import col
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

conf = SparkConf().setAppName("WordCount").set("spark.sql.catalogImplementation", "hive")

sc = SparkContext(conf=conf)
spark = SparkSession(sc)

input = sc.textFile(sys.argv[1])

words = input.flatMap(lambda line: line.split(" "))
wordCounts = words.map(lambda word: (word, 1)).reduceByKey(lambda count1, count2: count1 + count2)

wordCounts.saveAsTextFile(sys.argv[2])

# 将结果保存到已有的Hive表中
spark.sql("CREATE DATABASE IF NOT EXISTS my_db")

# 创建Hive表
schema = StructType([StructField("word", StringType(), True), StructField("count", IntegerType(), True)])
wordCountList = wordCounts.collect()
df = spark.createDataFrame(wordCountList, schema)
df.write.mode("overwrite").insertInto("my_db.test")

sc.stop()

