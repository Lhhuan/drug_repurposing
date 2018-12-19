library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/gene_network_merge_data/test_data/")

org<-read.table("./output/03_filter_test_data_for_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
org2<-org %>% dplyr::select(average_effective_drug_target_score,averge_mutation_frequency,averge_mutation_pathogenicity,averge_mutation_map_to_gene_level_score
                            ,average_the_shortest_path_length,min_rwr_normal_P_value,median_rwr_normal_P_value,cancer_gene_exact_match_drug_target_ratio,average_del_svscore
                            ,average_dup_svscore,average_inv_svscore,average_tra_svscore,average_cnv_svscore,drug_repurposing)

normalization<-function(x){
  return((x-min(x))/(max(x)-min(x)))} #将feature 归一化
org1<-apply(org2,2,normalization)%>%data.frame()  #apply函数是按照normalization对org2表格按列处理
#将org1数据分成随机十等分
#install.packages("caret")
#固定folds函数的分组
set.seed(7)
require(caret)
folds <- createFolds(y=org1$drug_repurposing,k=5)

#构建for循环，得5次交叉验证的测试集精确度、训练集精确度
max=0
num=0
rs <- data.frame()#构造一个表
for(i in 1:5){
  
  fold_test <- org1[folds[[i]],]   #取folds[[i]]作为测试集
  fold_train <- org1[-folds[[i]],]   # 剩下的数据作为训练集
  
  print("***组号***")
  
  fold_pre <- glm(drug_repurposing ~.,family=binomial(link='logit'),data=fold_train)
  fold_predict <- predict(fold_pre,type='response',newdata=fold_test)
  fold_predict1 =ifelse(fold_predict>0.5,1,0)
  fold_test$predict = fold_predict1
  #----------------------------------------------
  true_value1 =fold_test[,14]
  #--------------------------把所有的被预测的测试数据的结果放到一个表里
  tmp<-data.frame(true_value1= fold_test[,14],predict_value1=fold_predict)
  rs <- bind_rows(rs,tmp)
  #---------------------------
  fold_error = fold_test[,15]-fold_test[,14]
  fold_accuracy = (nrow(fold_test)-sum(abs(fold_error)))/nrow(fold_test) 
  print(i)
  print("***测试集精确度***")
  print(fold_accuracy)
  print("***训练集精确度***")
  fold_predict2 <- predict(fold_pre,type='response',newdata=fold_train)
  fold_predict2 =ifelse(fold_predict2>0.5,1,0)
  fold_train$predict = fold_predict2
  fold_error2 = fold_train[,15]-fold_train[,14]
  fold_accuracy2 = (nrow(fold_train)-sum(abs(fold_error2)))/nrow(fold_train) 
  print(fold_accuracy2)
  
  
  if(fold_accuracy>max)
  {
    max=fold_accuracy  
    num=i
  }
  
}

print(max)
print(num)

#----------------------------
library(pROC)
modelroc <- roc(rs$true_value1,rs$predict_value1)
plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,legacy.axes=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)        #画出ROC曲线，标出坐标，并标出AUC的值
#-----------------------------

library(ROCR)     
pred <- prediction(rs$predict_value1,rs$true_value1)   #预测值(0.5二分类之前的预测值)和真实值   
performance(pred,'auc')@y.values        #AUC值
perf <- performance(pred,'tpr','fpr')
plot(perf)
#-----------------------------



