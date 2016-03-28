###Prepare RHadoop
###Put data file to hdfs
system("bin/hdfs dfs -put /Users/Mengying/Desktop/AMS691/AMS691_Project1_stockA_5min.csv /user/hadoop/proj1data ")
proj1.format<-make.input.format("csv",sep=",")
proj1<-"/user/hadoop/proj1data"


###Map function, key=return
proj1.map<-function(k,v)
{
		#calculate return, close-open/open
		return<-(v[[5]]-v[[2]])/v[[2]]
		Return<-round(return,digits=6)	#use 6 decimal digits
		keyval(Return,1)
}

###Reduce function, sum(val)
proj1.reduce<-function(k,v)
{
		keyval(k,sum(v))
}

###Mapreduce
count<-mapreduce(proj1,map=proj1.map,reduce=proj1.reduce,input.format= proj1.format)

###Get results from dfs
results=from.dfs(count)
results.df=as.data.frame(results,stringsAsFactors=F)
colnames(results.df) = c("Return","Count")

###Plot histogram
plot(results.df,type="h")

plot(results.df[-1,],type="h",ylim=c(0,250),main="Empirical Distribution for Returns on 5-minute Intervals")
abline(v=0)
legend(0.01,250,"Return=0.00,Count=15722")
