library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
library(tidyverse)
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/huan_data/output")
dit <-"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/huan_data/output/"
main_cancer<-read_tsv(file.path(dit, "network_based_logic_true_drug_count_in_main_cancer.txt")) %>% as.data.frame()
detail_cancer<-read_tsv(file.path(dit, "network_based_logic_true_drug_count_in_detail_cancer.txt")) %>% as.data.frame()

main_cancer<-main_cancer%>%arrange(desc(drug_number))
detail_cancer<-detail_cancer%>%arrange(desc(drug_number))
main_overall_p<-main_cancer$percentage[1]
main_cancer <- mutate(main_cancer,odds_ratio=percentage/main_overall_p, overall_pencertage =main_overall_p,final_percentage =percentage - main_overall_p  )
detail_overall_p<-detail_cancer$percentage[1]
detail_cancer <- mutate(detail_cancer,odds_ratio=percentage/detail_overall_p,overall_pencertage =detail_overall_p, final_percentage =percentage - detail_overall_p )

le_m<-nrow(main_cancer)
rs <- data.frame()#构造一个表
for(i in 1:le_m ){
  aa<- main_cancer[i,3]
  bb<- main_cancer[i,4]
  p_t_main<-prop.test(x = c(aa, 102415), n = c(bb, 130856))
  p_main<-data.frame(p_t_main[3],p_t_main$conf.int[1],p_t_main$conf.int[2])
  rs <- bind_rows(rs,p_main)
}
main_cancer<-cbind(main_cancer,rs)
#----------------------------------- detail 
le_d<-nrow(detail_cancer)
rs_d <- data.frame()#构造一个表

for(i in 1:le_d ){
  aa<- detail_cancer[i,3]
  bb<- detail_cancer[i,4]
  p_t_d<-prop.test(x = c(aa, 191964), n = c(bb, 303348))
  p_d<-data.frame(p_t_d[3],p_t_d$conf.int[1],p_t_d$conf.int[2])
  rs_d <- bind_rows(rs_d,p_d)
}
detail_cancer<-cbind(detail_cancer,rs_d)
write.table(main_cancer,"network_based_main_cancer_proportion_test.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
write.table(detail_cancer,"network_based_detail_cancer_proportion_test.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
