library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
library(tidyverse)
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/huan_data/output")
dit <-"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/huan_data/output/"
main_cancer<-read_tsv(file.path(dit, "gene_based_logic_true_drug_count_in_main_cancer.txt")) %>% as.data.frame()
detail_cancer<-read_tsv(file.path(dit, "gene_based_logic_true_drug_count_in_detail_cancer.txt")) %>% as.data.frame()
le_m<-nrow(main_cancer)
rs <- data.frame()#构造一个表
for(i in 1:le_m ){
  aa<- main_cancer[i,3]
  p_t_main<-prop.test(aa, 5948)
  p_main<-p_t_main[3]%>%as.data.frame()
  rs <- bind_rows(rs,p_main)
}
main_cancer<-cbind(main_cancer,rs)
#-----------------------------------
le_d<-nrow(detail_cancer)
rs_d <- data.frame()#构造一个表

for(i in 1:le_d ){
  aa<- detail_cancer[i,3]
  p_t_d<-prop.test(aa, 5948)
  p_d<-p_t_d[3]%>%as.data.frame()
  rs_d <- bind_rows(rs_d,p_d)
}
detail_cancer<-cbind(detail_cancer,rs_d)
write.table(main_cancer,"gene_based_main_cancer_proportion_test.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
write.table(detail_cancer,"gene_based_detail_cancer_proportion_test.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
