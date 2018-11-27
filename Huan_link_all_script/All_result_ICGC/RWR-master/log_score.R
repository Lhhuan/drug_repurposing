mat1<-as.matrix(read.csv("Maccs_predict_drug.csv",header=T,row.names=1))
mat2<-as.matrix(read.csv("Maccs_predict.csv",header=T,row.names=1))
final.mat<-(t(log10(mat1))+(log10(mat2)))/2
d<-colMeans(final.mat)
c<-as.matrix(d)
ss<-mat.or.vec(727,2)

for (i in 1:727){
  for ( j in 1:3519){
    ss[i,1]<-ss[i,1]+(final.mat[j,i]-c[i])^2
    
  }
  
}
sd<-mat.or.vec(727,2)

for (i in 1:727){
  sd[i,1]<-sqrt(ss[i,1]/3519)
  
}

rawscore<-mat.or.vec(3519,727)

for ( i in 1:3519){
  for ( j in 1:727){
    rawscore[i,j]<-(final.mat[i,j]-c[j])/sd[j]
    
    
  }
}