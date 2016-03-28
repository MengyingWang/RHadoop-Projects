#environment settings
Sys.setenv("HADOOP_PREFIX"="/Users/hadoop/hadoop-2.7.1")
Sys.setenv("HADOOP_CMD"="/Users/hadoop/hadoop-2.7.1/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="/Users/hadoop/hadoop-2.7.1/share/hadoop/tools/lib/hadoop-streaming-2.7.1.jar")

#install packages
install.packages(c("rJava", "Rcpp", "RJSONIO", "rjson","bitops", "digest","functional", "stringr", "plyr", "reshape2", "dplyr", "R.methodsS3", "caTools", "Hmisc", "memoise","data.table"))
library(bitops)
library(caTools)
library(data.table)
library(digest)
library(dplyr)
library(functional)
library(Hmisc)
library(memoise)
library(plyr)
library(R.methodsS3)
library(Rcpp)
library(reshape2)
library(rJava)
library(rjson)
library(RJSONIO)
library(stringr)

#Download packages rmr2, plyrmr and rhdfs from https://github.com/RevolutionAnalytics/RHadoop/wiki to a local directory, and install them. 

install.packages("/Users/Mengying/Downloads/hadoop/rmr2_3.3.1.tar.gz", repos=NULL, type="source")
install.packages("/Users/Mengying/Downloads/hadoop/plyrmr_0.6.0.tar.gz", repos=NULL, type="source")
install.packages("/Users/Mengying/Downloads/hadoop/rhdfs_1.0.8.tar.gz", repos=NULL, type="source")

library(rmr2)
library(plyrmr)
library(rhdfs)
hdfs.init()

### run R job in Hadoop
## copy local file to hdfs
#run below code in terminal or use system()function in R
bin/hdfs dfs -put [local file path] [destination path]

## start hadoop in r
setwd("/Users/hadoop/hadoop-2.7.1")
system("bin/hdfs namenode -format")
system("sbin/start-dfs.sh")
system("bin/hdfs dfs -mkdir /user")
system("bin/hdfs dfs -mkdir /user/hadoop")
## function such as map&reduce
