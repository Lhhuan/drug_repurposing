library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/gene_network_merge_data/huan_data/")
#---------------训练集
org<-read.table("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/gene_network_merge_data/test_data/output/03_filter_test_data_for_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
org1<-org %>% dplyr::select(average_effective_drug_target_score,averge_mutation_frequency,averge_mutation_pathogenicity,averge_mutation_map_to_gene_level_score
                            ,average_the_shortest_path_length,min_rwr_normal_P_value,median_rwr_normal_P_value,cancer_gene_exact_match_drug_target_ratio,average_del_svscore
                            ,average_dup_svscore,average_inv_svscore,average_tra_svscore,average_cnv_svscore,drug_repurposing)
#需要预测的数据
test_huan<-read.table("./output/04_calculate_features_for_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
test_huan1<-test_huan%>%dplyr::select(average_effective_drug_target_score,averge_mutation_frequency,averge_mutation_pathogenicity,averge_mutation_map_to_gene_level_score
                                      ,average_the_shortest_path_length,min_rwr_normal_P_value,median_rwr_normal_P_value,cancer_gene_exact_match_drug_target_ratio,average_del_svscore
                                      ,average_dup_svscore,average_inv_svscore,average_tra_svscore,average_cnv_svscore)
#----------------------------------------------------------------------------------------------------
#生成logis模型，用glm函数
#用训练集数据生成logis模型，用glm函数
#family：每一种响应分布（指数分布族）允许各种关联函数将均值和线性预测器关联起来。常用的family：binomal(link='logit')--响应变量服从二项分布，连接函数为logit，即logistic回归
#---------------------------------------------------------------------- 
#测试集的真实值
pre <- glm(drug_repurposing ~.,family=binomial(link = "logit"),data = org1)
summary(pre)
summary(test_huan1)
#predict函数可以获得模型的预测值。这里预测所需的模型对象为pre，预测对象newdata为测试集,预测所需类型type选择response,对响应变量的区间进行调整

predict. <- predict.glm(pre,type='response',newdata=test_huan1)
#按照预测值为1的概率，>0.5的返回1，其余返回0
predict =ifelse(predict.>0.75,1,0)
#把预测的具体值记录下来
predict_value = predict.
#数据中加入预测值一列
test_huan1$predict = predict
test_huan1$predict_value = predict_value
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/gene_network_merge_data/huan_data/output/")
write.table(test_huan1,"05_logistic_regression_prediction_potential_drug_repurposing_data.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
#------------------------------------------------
