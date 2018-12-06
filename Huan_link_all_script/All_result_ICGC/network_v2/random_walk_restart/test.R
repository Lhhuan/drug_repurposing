data<-c(4,5,6,11)
#data<-c(235,888,502,35206)

counts<-matrix(data,nrow=2)

fisher.test(counts)
 
re<-fisher.test(counts)
p <-re$p.value
