library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/validation/gdkb_cgi_oncokb_mtctscan/")
#---------------训练集
dit<-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/test_data/"
org<-read.table(file.path(dit,"./output/09_filter_test_data_for_logistic_regression.txt"),header = T,sep = "\t") %>% as.data.frame()
org2<-org %>% dplyr::select(average_effective_drug_target_score,max_effective_drug_target_score,
                            average_mutation_frequency,max_mutation_frequency,average_mutation_pathogenicity,
                            max_mutation_pathogenicity,average_mutation_map_to_gene_level_score
                            # max_mutation_pathogenicity,average_mutation_map_to_gene_level_score,max_mutation_map_to_gene_level_score
                            ,average_the_shortest_path_length,min_the_shortest_path_length,min_rwr_normal_P_value,
                            median_rwr_normal_P_value,cancer_gene_exact_match_drug_target_ratio,average_del_svscore
                            # ,average_dup_svscore,average_inv_svscore,average_tra_svscore,average_cnv_svscore,drug_repurposing)
                            ,average_dup_svscore,average_inv_svscore,average_cnv_svscore)

normalization<-function(x){
  return((x -mean(x)) / sd(x))} #将feature 归一化
org1<-apply(org2,2,normalization)%>%data.frame()  #apply函数是按照normalization对org2表格按列处理
org1$drug_repurposing <-org$drug_repurposing

#需要预测的数据
huan<-read.table("./output/07_merge_negative_positive.txt",header = T,sep = "\t") %>% as.data.frame()
#huan_drug_cancer<-huan%>%dplyr::select(Drug_chembl_id_Drug_claim_primary_name,cancer_oncotree_id,cancer_oncotree_id_type)
huan_drug_cancer<-huan%>%dplyr::select(Drug_chembl_id_Drug_claim_primary_name,cancer_oncotree_id,cancer_oncotree_id_type,sample_type)
huan2<-huan%>%dplyr::select(average_effective_drug_target_score,max_effective_drug_target_score,
                            average_mutation_frequency,max_mutation_frequency,average_mutation_pathogenicity,
                            max_mutation_pathogenicity,average_mutation_map_to_gene_level_score
                            # max_mutation_pathogenicity,average_mutation_map_to_gene_level_score,max_mutation_map_to_gene_level_score
                            ,average_the_shortest_path_length,min_the_shortest_path_length,min_rwr_normal_P_value,
                            median_rwr_normal_P_value,cancer_gene_exact_match_drug_target_ratio,average_del_svscore
                            ,average_dup_svscore,average_inv_svscore,average_cnv_svscore)
#-------------------------------------------对test dataset 进行normalization
mean_data<-function(x){
  return(mean(x))
}
training_mean<- apply(org2,2,mean_data)%>%data.frame() 

sd_data<-function(x){
  return(sd(x))
}
training_sd<- apply(org2,2,sd_data)%>%data.frame()

training<-cbind(training_mean,training_sd)
training<-data.frame(t(as.matrix(training))) #行列转换 #此时training_mean是第一行，training_sd是第二行
# training<-training%>%dplyr::select(-drug_repurposing) #把drug_repurposing这一列减掉

test=rbind(training,huan2)


huan1<- apply(test,2,function(x){ 
  return((x[3:length(x)]-x[1])/x[2]) #对每一列的第三行往后进行操作，这里和使用training_mix和training_max进行test dataset进行normalization
})%>%data.frame

#----------------------------------------------------------------------------------------------------
#生成logis模型，用glm函数
#用训练集数据生成logis模型，用glm函数
#family：每一种响应分布（指数分布族）允许各种关联函数将均值和线性预测器关联起来。常用的family：binomal(link='logit')--响应变量服从二项分布，连接函数为logit，即logistic回归
#---------------------------------------------------------------------- 
#测试集的真实值
#org1=cbind(org1,drug_repo)
pre <- glm(drug_repurposing ~.,family=binomial(link = "logit"),data = org1)
summary(pre)
summary(org1)
summary(huan1)
#predict函数可以获得模型的预测值。这里预测所需的模型对象为pre，预测对象newdata为测试集,预测所需类型type选择response,对响应变量的区间进行调整

predict. <- predict.glm(pre,type='response',newdata=huan1)
#按照预测值为1的概率，>0.5的返回1，其余返回0
predict =ifelse(predict.>0.338,1,0)
#把预测的具体值记录下来
predict_value = predict.
#数据中加入预测值一列
huan1$predict = predict
huan1$predict_value = predict_value
final_huan <- cbind(huan_drug_cancer,huan1)
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/validation/gdkb_cgi_oncokb_mtctscan/output/")
write.table(final_huan,"08_Independent_sample_repurposing.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
#------------------------------------------------
