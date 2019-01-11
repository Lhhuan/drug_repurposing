library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)

setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/")
#org<-read.table("./output/11_prediction_and_icgc_result.txt",header = T,sep = "\t") %>% as.data.frame()
org<-read.table("./output/11_prediction_and_icgc_result.txt",header = T,sep = "\t") %>% as.data.frame()
org1 <- org%>%arrange((value_in_paper)) #对org按照value_in_paper进行升序排列
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/")
write.table(org1,"11_prediction_and_icgc_result_sorted_by_value_in_paper.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
