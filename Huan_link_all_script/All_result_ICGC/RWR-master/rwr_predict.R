M1<-as.matrix(read.csv("M_rocs_loo.csv",header=T,row.names=1))
M<-as.matrix(read.csv("db_prot_loo.csv",header=T,row.names=1))
M2<-1*t(M)
d<-0*diag(727)
#po<-mat.or.vec(3519,727)
PO<-rbind(M2,d)
PT<-rbind(M2,d)
for (i in 1:727){
  for ( j in 1:20){
    PT[,i]<-0.3*t(M1)%*%PT[,i]+0.7*PO[,i]
    
  }
  
}

write.csv(PT,"M_rocs_loo_1.csv")