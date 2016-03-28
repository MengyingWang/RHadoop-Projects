#K-Means Clustering using MapReduce framework

kmeans.mr = function(P, num.clusters, num.iter) {
    
	dist.fun = function(C, P) {    
        	apply(C, 1, function(x) colSums((t(P) - x)^2))  
	}    
    
	kmeans.map = function(., P) {    
     		if(is.null(C)) {      
          		nearest = sample(1:num.clusters, nrow(P), replace = TRUE)    
     		}   
     		else {      
          		D = dist.fun(C, P) 
          		nearest = max.col(-D)    
     		} 
		keyval(nearest, P)   
	}
    
	kmeans.reduce = function(., P) {    
     		t(as.matrix(apply(P, 2, mean)))  
        }    

 	C = NULL  
 	for(i in 1:num.iter ) {    
     		C = values(from.dfs(mapreduce(P, map = kmeans.map, reduce = kmeans.reduce)))  
 	} 

	if(nrow(C) < num.clusters) {   
		C = rbind(C, matrix(rnorm((num.clusters - nrow(C)) * nrow(C)), ncol =  nrow(C)) %*% C) 
	}  
	return(c)
}

#Example, using data of Iris flowers
#https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data


library(rmr2)
out = kmeans.mr(to.dfs(P), num.clusters = 3, num.iter = 5)

D <- dist.fun(out, P)
nearest <- max.col(-D)
table(data[[5]], nearest)
#Plot clustering results and compare with known classification
par(mfrow = c(1, 2))
plot(P[,3:4], col = nearest, main = “plot by k-means”)
plot(P[,3:4], col = data[[5]], main = "plot of original classes")
plot(P[,1:2], col = nearest, main = “plot by k-means”)
plot(P[,1:2], col = data[[5]], main = "plot of original classes")
