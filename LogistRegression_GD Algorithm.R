#logist regression
#probabaility estimation

g=function(z){
	1/(1+exp(-z))
}

#mapper:calculate the contribution of a subset of points to the gradient

lr.map=function(.,M){
	Y=M[,1]
	X=M[,-1]
	keyval(1,t(t(X)%*%(g(X%*%beta)-Y)))
}


#reducer: perform sum operation over mapper output

lr.reduce=function(k,Z){
	keyval(k,t(as.matrix(apply(Z,2,sum))))
}

#MapReduce job  Defining MapReduce function for executing logist regression
#input: data input
#iterations: for optimization
#dims: parameter dimension
#gamma:step size

lr.gd=function(input,iterations,dims,gamma){
	
	lr.map=function(.,M){
		Y=M[,1]
		X=M[,-1]
		keyval(1,t(t(X)%*%(g(X%*%t(beta))-Y)))
	}
	
	lr.reduce=function(k,Z){
		keyval(k,t(as.matrix(apply(Z,2,sum))))
	}

	g=function(z){
		1/(1+exp(-z))
	}
	beta=t(rep(0,dims))
	for(i in 1:iterations){
		gradient=values(
			from.dfs(
				mapreduce(input,map=lr.map,reduce=lr.reduce,combine=T)
				)
			)
		beta=beta-gamma*gradient
	}
	beta
}

beta<-lr.gd( , , , )
class(beta)  #matrix   1*dims

cov_beta<-function(input,beta){
	g=function(z){
		1/(1+exp(-z))
	}
	
	mapper1<-function(.,m){
			x<-m[,-1]
			D=diag(as.vector(g(x%*%t(beta))))%*%diag(as.vector(1-g(x%*%t(beta))))
			keyval(1,list(t(x)%*%D%*%x))
		}
	sum<-function(k,v){
		keyval(k,list(Reduce("+",v)))
	}
	
	xt_D_x<-values(from.dfs(mapreduce(input,map=mapper1,reduce=sum,combine=T)))[[1]]
    return(solve(xt_D_x))

}

cov_beta<-cov_beta( , beta)


#create test data
test.size=10000
set.seed(0)
eps=rnorm(test.size)
testdata=to.dfs(
	as.matrix(
		data.frame(y=as.integer(eps>0),x1=1:test.size,x2=rbinom(test.size,1,0.6))
	)
)




##run an example using data from package{catdata}
install.packages("catdata")
library(catdata)
data(foodstamp)
testdata<-to.dfs(as.matrix(foodstamp))
print(logistic.regression(testdata,iterations=100,dims=3,gamma=0.05))
