library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(caret)
library(lattice)
library(e1071) #libsvm
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V10/test_data/")

org<-read.table("./output/09_filter_test_data_for_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
# org2<-org %>% dplyr::select(average_effective_drug_target_score,average_mutation_frequency,average_mutation_pathogenicity,average_mutation_map_to_gene_level_score
#                             ,average_the_shortest_path_length,min_rwr_normal_P_value,median_rwr_normal_P_value,cancer_gene_exact_match_drug_target_ratio,average_del_svscore
#                             ,average_dup_svscore,average_inv_svscore,average_tra_svscore,average_cnv_svscore,drug_repurposing)

org2<-org %>% dplyr::select(average_effective_drug_target_score,max_effective_drug_target_score,
                            average_mutation_frequency,max_mutation_frequency,average_mutation_pathogenicity,
                            max_mutation_pathogenicity,average_mutation_map_to_gene_level_score
                            # max_mutation_pathogenicity,average_mutation_map_to_gene_level_score,max_mutation_map_to_gene_level_score
                            ,average_the_shortest_path_length,min_the_shortest_path_length,min_rwr_normal_P_value,
                            median_rwr_normal_P_value,cancer_gene_exact_match_drug_target_ratio,average_del_svscore
                            # ,average_dup_svscore,average_inv_svscore,average_tra_svscore,average_cnv_svscore,drug_repurposing)
                            ,average_dup_svscore,average_inv_svscore,average_tra_svscore,average_cnv_svscore)
# ,average_dup_svscore,average_inv_svscore,average_cnv_svscore)

# normalization<-function(x){
#   return((x-min(x))/(max(x)-min(x)))} #将feature 归一化
normalization<-function(x){
  return((x -mean(x)) / sd(x))} #将feature 归一化
org1<-apply(org2,2,normalization)%>%data.frame()  #apply函数是按照normalization对org2表格按列处理
org1$max_mutation_map_to_gene_level_score <-org$max_mutation_map_to_gene_level_score
# org1$drug_repurposing <-org$drug_repurposing




svm_test <- function(x,y){
  type <- c('C-classification','nu-classification','one-classification', 'eps-regression','nu-regression')
  kernel <- c('linear','polynomial','radial','sigmoid')
  pred <- array(0, dim=c(nrow(x),5,4))
  errors <- matrix(0,5,4)
  dimnames(errors) <- list(type, kernel)
  for(i in 1:5){
    for(j in 1:4){
      pred[,i,j] <- predict(object = svm(x, y, type = type[i], kernel = kernel[j]), newdata = x)
      if(i > 2) errors[i,j] <- sum(pred[,i,j] != 1)
      else errors[i,j] <- sum(pred[,i,j] != as.integer(y))
       }
    }
  return(errors)
  }




svm_test(x=org1,y=org$drug_repurposing)

