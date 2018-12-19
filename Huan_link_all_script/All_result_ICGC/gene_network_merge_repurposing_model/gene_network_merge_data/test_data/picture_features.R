library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)

setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/gene_network_merge_data/test_data/")
org<-read.table("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/gene_network_merge_data/test_data/output/03_filter_test_data_for_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
