library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)

setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/")
#org<-read.table("./output/11_prediction_and_icgc_result.txt",header = T,sep = "\t") %>% as.data.frame()
org<-read.table("./output/11_prediction_and_icgc_result_top0.1.txt",header = T,sep = "\t") %>% as.data.frame()

org1 <-org%>% dplyr::select(predict_value,value_in_paper)
ccc<-cor.test(org$predict_value, org$value_in_paper,alternative = "greater", method = "pearson")
