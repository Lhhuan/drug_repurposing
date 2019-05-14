library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/validation/gdkb_cgi_oncokb_mtctscan/")
org<-read.table("./output/08_Independent_sample_repurposing.txt",header = T,sep = "\t") %>% as.data.frame()
org1 <- org%>%arrange(desc(predict_value)) #对org按照value_in_paper进行升序排列
write.table(org1,"./output/08_sorted_Independent_sample_repurposing.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
