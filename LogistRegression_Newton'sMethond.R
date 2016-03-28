lr.newton=function(input,iterations,dims){
	
	g=function(z){
		1/(1+exp(-z))
	}
	
	sum<-function(k,v){
		keyval(k,list(Reduce("+",v)))
	}
	
	beta=t(rep(1,dims))
#calculate H matrix
	for(i in 1:iterations){
		mapper1<-function(.,m){
			x<-m[,-1]
			D=diag(as.vector(g(x%*%t(beta))))%*%diag(as.vector(1-g(x%*%t(beta))))
			keyval(1,list(t(x)%*%D%*%x))
		}

		xtx<-values(from.dfs(mapreduce(input,map=mapper1,reduce=sum,combine=T)))[[1]]
		invH<-solve(xtx)

#calculate [x'(y-pie)]
	
		mapper2=function(.,M){
			Y=M[,1]
			X=M[,-1]
			keyval(1,list(t(X)%*%(g(X%*%t(beta))-Y)))
		}
	
		xty=values(
				from.dfs(
					mapreduce(input,map=mapper2,reduce=sum,combine=T)
					)
				)[[1]]
		new_beta<-solve(xtx,xty)
		beta=beta+t(new_beta)
		}
	beta
	return(list(beta,invH))
}

beta_invH<-lr.newton(food,2,3)

#cov(beta)=solve(D)
#H0: beta1=0   test statistic z=beta1_hat/sd(beta1)=beta[1]/sqrt(D[1,1])~N(0,1)
#p-value=pnorm(abs(z),lower.tail=F)*2
