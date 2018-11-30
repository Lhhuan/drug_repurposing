library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
setwd("/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model_both/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/")
#---------------训练集
org<-read.table("11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt",header = T,sep = "\t") %>% as.data.frame()
org1<-org %>% dplyr::select(average_drug_score,averge_gene_mutation_frequency,average_gene_CADD_score,average_mutation_map_to_gene_level_score,
                            averge_gene_num_in_del_hotspot,averge_gene_num_in_dup_hotspot,averge_gene_num_in_cnv_hotspot,averge_gene_num_in_inv_hotspot,
                            averge_gene_num_in_tra_hotspot,repo_info)
#需要预测的数据
test_huan<-read.table("/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model_both/Gene-based_drug_R_or_S_optimization/huan_data/output/023_calculate_for_gene_based_repo_logistic_regression_data_final.txt",header = T,sep = "\t") %>% as.data.frame()
test_huan1<-test_huan%>%dplyr::select(average_drug_score,averge_gene_mutation_frequency,average_gene_CADD_score,average_mutation_map_to_gene_level_score,
                                      averge_gene_num_in_del_hotspot,averge_gene_num_in_dup_hotspot,averge_gene_num_in_cnv_hotspot,averge_gene_num_in_inv_hotspot,
                                      averge_gene_num_in_tra_hotspot)
#----------------------------------------------------------------------------------------------------
#生成logis模型，用glm函数
#用训练集数据生成logis模型，用glm函数
#family：每一种响应分布（指数分布族）允许各种关联函数将均值和线性预测器关联起来。常用的family：binomal(link='logit')--响应变量服从二项分布，连接函数为logit，即logistic回归
#---------------------------------------------------------------------- 
#测试集的真实值
pre <- glm(repo_info ~.,family=binomial(link = "logit"),data = org1)
summary(pre)
#predict函数可以获得模型的预测值。这里预测所需的模型对象为pre，预测对象newdata为测试集,预测所需类型type选择response,对响应变量的区间进行调整

predict. <- predict.glm(pre,type='response',newdata=test_huan1)
#按照预测值为1的概率，>0.5的返回1，其余返回0
predict =ifelse(predict.>0.5,1,0)
#把预测的具体值记录下来
predict_value = predict.
#数据中加入预测值一列
test_huan1$predict = predict
test_huan1$predict_value = predict_value
setwd("/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model_both/Gene-based_drug_R_or_S_optimization/huan_data/output/")
write.table(test_huan1,"prediction_repurposing.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
 #------------------------------------------------
