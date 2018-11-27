a<-read.csv("PHFP4_predict_loo_1.csv",header=T,row.names=1)
#a<-t(a)
#b<-read.csv("db_prot_loo.csv",header=T,row.names=1)
#c<-read.csv("db_prot.csv",header=T,row.names=1)
#c<-t(c)
#min<- c-b
#write.csv(min,"unmatched.csv")
#min<-read.csv("unmatched.csv",header=T,row.names=1)
for ( i in 1:727){
  m<-a[order(-a[,c(i)]), ,drop=FALSE]
  #print(m)
  name<-rownames(min)[min[,i]>0]
  nm<-rownames(m)
  if( length(name)>0){
    rank<-which(nm==name)
    print(rank)
    #print(name)
    #  write.table(rank,"ranks.csv",append=TRUE)
  }
}

#ranks<-read.csv("ranks.csv",header=T)
a<-as.data.frame(table(ranks$ROCS_0.99))
#head(a)
a$cf<-cumsum(a$Freq)
for (i in 1:nrow(a)){
  a$foi[i]<-(a$cf[i])/684
}

d<-data.frame()
r<-c("1","2","3","5","8","10","25","49","100")
for ( i in r){
  data<-a[a$Var1==i,]
  d<-rbind(d,data)
}
d
l<-"\n"
write.table(l,"ROCS_1.csv",append=TRUE,col.names=FALSE)
write.table(d,"ROCS_1.csv",append=TRUE,col.names=FALSE)


