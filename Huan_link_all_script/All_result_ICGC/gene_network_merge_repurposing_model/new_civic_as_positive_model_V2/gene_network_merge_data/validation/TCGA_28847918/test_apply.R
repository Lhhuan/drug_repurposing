library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)



setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/")
#---------------训练集
#org<-read.table("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/test_data/output/09_filter_test_data_for_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
train_a<-read.table("test_header.txt",header = T,sep = "\t") %>% as.data.frame()
train_b<-train_a %>% dplyr::select(average_effective_drug_target_score,average_mutation_frequency,average_mutation_pathogenicity,average_mutation_map_to_gene_level_score
                            ,average_the_shortest_path_length,min_rwr_normal_P_value,median_rwr_normal_P_value,cancer_gene_exact_match_drug_target_ratio,average_del_svscore
                            ,average_dup_svscore,average_inv_svscore,average_tra_svscore,average_cnv_svscore,drug_repurposing)

test_a<-read.table("test_header2.txt",header = T,sep = "\t") %>% as.data.frame()
test_b<-test_a %>% dplyr::select(average_effective_drug_target_score,average_mutation_frequency,average_mutation_pathogenicity,average_mutation_map_to_gene_level_score
                                   ,average_the_shortest_path_length,min_rwr_normal_P_value,median_rwr_normal_P_value,cancer_gene_exact_match_drug_target_ratio,average_del_svscore
                                   ,average_dup_svscore,average_inv_svscore,average_tra_svscore,average_cnv_svscore)


normalization<-function(x){
  return((x-min(x))/(max(x)-min(x)))}
train_c<-apply(train_b,2,normalization)%>%data.frame()  #2代表列，1代表行

mix_data<-function(x){
  return(min(x))
}
training_mix<- apply(train_b,2,mix_data)%>%data.frame() 

max_data<-function(x){
  return(max(x))
}
training_max<- apply(train_b,2,max_data)%>%data.frame()

training=cbind(training_mix,training_max)
training=data.frame(t(as.matrix(training))) #行列转换 #此时training_mix是第一行，training_max是第二行
normalization_test<-function(x,y){
 # return((x-training_mix(x))/(training_max(x)-training_mix(x)))
  return((x-y[1])/(y[2]-y[1]))
}
features=colnames(test_b)


training=training[,features] #把training转换成和test_b一样的排列顺序
test=rbind(training,test_b)


re=apply(test,2,function(x){ 
  return((x[3:length(x)]-x[1])/(x[2]-x[1])) #对每一列的第三行往后进行操作，这里和使用training_mix和training_max进行test dataset进行normalization
})%>%data.frame





for(i in 1:ncol(test_b)){ #逐列循环
  for (j in 1:nrow(test_b)){ #逐行循环
    t=features[i]
    norm[j,i]=normalization_test(test_b[j,i],training[,i]) #给函数传入参数
  }
}


