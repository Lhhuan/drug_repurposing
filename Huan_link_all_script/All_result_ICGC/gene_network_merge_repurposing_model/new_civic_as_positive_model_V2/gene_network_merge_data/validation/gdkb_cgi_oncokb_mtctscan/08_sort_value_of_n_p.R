library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)

setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/gdkb_cgi_oncokb_mtctscan/")
#org<-read.table("./output/11_prediction_and_icgc_result.txt",header = T,sep = "\t") %>% as.data.frame()
org<-read.table("./output/07_merge_negative_positive.txt",header = T,sep = "\t") %>% as.data.frame()
org1 <- org%>%arrange(desc(predict_value)) #对org按照value_in_paper进行升序排列
write.table(org1,"./output/07_sorted_merge_negative_positive.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
