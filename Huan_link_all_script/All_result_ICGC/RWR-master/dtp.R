b<-as.matrix(read.csv("/Users/abhikseal/Documents/db_prot.csv",header=T,row.names=1))
d<-as.matrix(read.csv("samplepredictions_1.csv",header=T,row.names=1))
d[d < 0]<-0
b<-b[,colnames(d)]
c<-d
c[b>0]<-1
write.csv(c,"matches.csv")

for ( i in 1:110){
a<-c[order(-c[,c(i)]), ,drop=FALSE]
data<-as.data.frame(a[1:10,c(i)])
data$drug<-colnames(c)[i]
write.table(data,"matchedTargets.csv",append=TRUE,col.names=FALSE)
}

#Match tables and find the ranks

c<-as.matrix(read.csv("chemblmatch.csv",header=T,row.names=1))
d<-as.matrix(read.csv("/Users/abhikseal/Documents/rawscore_1.csv",header=T,row.names=1))


for (i in 1:ncol(c)){
cm<-c[order(-c[,i]), ,drop=FALSE]
name<-rownames(cm)[cm[,i]>0]
if (length(name) > 0){

  for (k in 1:ncol(d)){
      if(colnames(d)[k]==colnames(c)[i]){
          dm<-d[order(-d[,k]), ,drop=FALSE]
          for (j in 1:length(name)){
             rank<-which(names(dm[,k])==name[j])
             ranks <- as.data.frame(rank)
             ranks$drug<-colnames(d)[k]
             write.table(ranks,"rankeddata.csv",append=TRUE,col.names=FALSE)
          }
          }
        }
}
}

#Count true positives and false positves 
#Select target based on ranks
data1<-read.csv("chemblpredict.csv",header=T,row.names=1)
data2<-read.csv("chembldrugmap.csv",header=T,row.names=1)
data2<-data2[rownames(data1),colnames(data1)]
tp=fn=fp=specificity=sensitivity=precision=fpr=count=0
data1[data1 < 0]<-0

for (i in 1:ncol(data1)){
  cm<-data1[order(-data1[,i]), ,drop=FALSE]
  names.predicted<-rownames(cm)[cm[,i]>0][1:100]
  cd<-data2[order(-data2[,i]), ,drop=FALSE]
  names.test.tp<-rownames(cd)[cd[,i]>0]
  names.test.tn<-rownames(cd)[cd[,i]<=0]
  if (length(names.test.tp)<=0){
    next
  }
  else{
  tp<-length(names.test.tp)
  d<-names.test.tp %in% names.predicted
  t<-names.predicted %in% names.test.tn
  fn<-length(d[d!=TRUE])
  tn<-length(names.test.tn)
  fp <-length(t[t==TRUE])
  se<-(tp/(tp+fn))
  sp<-(tn/(fp+tn))
  s<-as.data.frame(se)
  s$drug<-colnames(data1)[i]
  write.table(s,"scorerank1.csv",append=TRUE,col.names=FALSE)
  sensitivity <- sensitivity+(tp/(tp+fn))
  specificity <- specificity+(tn/(fp+tn))
  precision<- precision+(tp/(tp+fp))
  fpr<-fpr+(fp/(fp+tn))
  count<-count+1
  }
}
sens<-sensitivity/count
spec<-specificity/count
Yindex<-sens+spec-1
ppr_rate<-precision/count
fpr_rate<-fpr/count
f<-2*(ppr_rate*sens)/(ppr_rate+sens)
acc<-accuracy/count
