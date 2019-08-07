library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(caret)
library(lattice)
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V3/test_data/")

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
org1$drug_repurposing <-org$drug_repurposing
#将org1数据分成随机十等分
#install.packages("caret")
#固定folds函数的分组
set.seed(7)
require(caret)
folds <- createFolds(y=org1$drug_repurposing,k=5)

#构建for循环，得5次交叉验证的测试集精确度、训练集精确度
rs <- data.frame()#构造一个表
for(i in 1:5){
  
  fold_test <- org1[folds[[i]],]   #取folds[[i]]作为测试集
  fold_train <- org1[-folds[[i]],]   # 剩下的数据作为训练集
  
  print("***组号***")
  
  fold_pre <- glm(drug_repurposing ~.,family=binomial(link='logit'),data=fold_train)
  fold_predict <- predict(fold_pre,type='response',newdata=fold_test)
  #----------------------------------------------
  true_value1 =fold_test[,19]
  #--------------------------把所有的被预测的测试数据的结果放到一个表里
  tmp<-data.frame(true_value1= fold_test[,19],predict_value1=fold_predict)
  rs <- bind_rows(rs,tmp)
}

#----------------------------
pdf("./output/ROC_of_model1_validation.pdf",height = 4,width = 5)
library(pROC)
modelroc <- roc(rs$true_value1,rs$predict_value1,direction=  "<")
plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,legacy.axes=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)        #画出ROC曲线，标出坐标，并标出AUC的值 # print.thres=TRUE 是print yuedan系数
dev.off()
#-----------------------------
library(plotROC)
pdf("./output/ROC_of_model1_validation_new.pdf",height = 4,width = 5)
p1 <- ggplot(rs, aes(d = true_value1, m = predict_value1)) + geom_roc(color="#448ef6",n.cuts = 0)
p1<-p1+annotate("text", x = .75, y = .25, size= 6,
                label = paste("AUC =", round(calc_auc(p1)$AUC, 3))) 

p1<-p1+xlab("1 - Specificity")+ylab("Sensitivity")
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 15),
                                                axis.title.x = element_text(size = 15),
                                                axis.line = element_line(colour = "black"))
p1
dev.off()
#-----------------------------

library(ROCR)
pred <- prediction(rs$predict_value1,rs$true_value1)   #预测值(0.5二分类之前的预测值)和真实值
performance(pred,'auc')@y.values        #AUC值
perf <- performance(pred,'tpr','fpr')
plot(perf)
# #-----------------------------



