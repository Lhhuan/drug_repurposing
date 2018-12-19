library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)

data<-matrix(1:16,nrow=4)
data<-as.data.frame(data)

normalization<-function(x){
  return((x-min(x))/(max(x)-min(x)))}
huanhu<-apply(data,2,normalization)
