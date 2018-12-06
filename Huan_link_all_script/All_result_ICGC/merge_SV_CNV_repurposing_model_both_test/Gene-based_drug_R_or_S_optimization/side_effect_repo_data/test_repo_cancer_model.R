library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
setwd("/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model_both_test/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/")

#6.更换测试集和训练集的选取方式，采用五折交叉验证
#--------------------- 
org<-read.table("13_final_data_for_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
#org1<-org %>% dplyr::select(Drug_claim_primary_name,oncotree_main_ID,average_drug_score,averge_gene_mutation_frequency,average_gene_CADD_score,average_mutation_map_to_gene_level_score,drug_repurposing)
org1<-org %>% dplyr::select(average_drug_score,averge_gene_mutation_frequency,average_gene_CADD_score,average_mutation_map_to_gene_level_score,
                            averge_gene_num_in_del_hotspot,averge_gene_num_in_dup_hotspot,averge_gene_num_in_cnv_hotspot,averge_gene_num_in_inv_hotspot,
                            averge_gene_num_in_tra_hotspot,repo_info)
#将org1数据分成随机十等分
#install.packages("caret")
#固定folds函数的分组
set.seed(7)
require(caret)
folds <- createFolds(y=org1$repo_info,k=5)

#构建for循环，得5次交叉验证的测试集精确度、训练集精确度
max=0
num=0
rs <- data.frame()#构造一个表
for(i in 1:5){
  
  fold_test <- org1[folds[[i]],]   #取folds[[i]]作为测试集
  fold_train <- org1[-folds[[i]],]   # 剩下的数据作为训练集
  
  print("***组号***")
  
  fold_pre <- glm(repo_info ~.,family=binomial(link='logit'),data=fold_train)
  fold_predict <- predict(fold_pre,type='response',newdata=fold_test)
  fold_predict1 =ifelse(fold_predict>0.5,1,0)
  fold_test$predict = fold_predict1
  #----------------------------------------------
  true_value1 =fold_test[,10]
  #--------------------------把所有的被预测的测试数据的结果放到一个表里
  tmp<-data.frame(true_value1= fold_test[,10],predict_value1=fold_predict)
  rs <- bind_rows(rs,tmp)
  #---------------------------
  fold_error = fold_test[,11]-fold_test[,10]
  fold_accuracy = (nrow(fold_test)-sum(abs(fold_error)))/nrow(fold_test) 
  print(i)
  print("***测试集精确度***")
  print(fold_accuracy)
  print("***训练集精确度***")
  fold_predict2 <- predict(fold_pre,type='response',newdata=fold_train)
  fold_predict2 =ifelse(fold_predict2>0.5,1,0)
  fold_train$predict = fold_predict2
  fold_error2 = fold_train[,11]-fold_train[,10]
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
modelroc <- roc(rs$true_value1,rs$predict_value)
plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,legacy.axes=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)        #画出ROC曲线，标出坐标，并标出AUC的值
#-----------------------------

library(ROCR)     
pred <- prediction(rs$predict_value,rs$true_value1)   #预测值(0.5二分类之前的预测值)和真实值   
performance(pred,'auc')@y.values        #AUC值
perf <- performance(pred,'tpr','fpr')
plot(perf)
#-----------------------------


#-----------------------------------------------------------------------------------------------
##结果可以看到，精确度accuracy最大的一次为max,取folds[[num]]作为测试集，其余作为训练集。
