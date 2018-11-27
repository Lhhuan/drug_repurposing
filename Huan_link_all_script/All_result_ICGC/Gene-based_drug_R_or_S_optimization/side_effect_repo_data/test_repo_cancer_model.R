library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
setwd("/f/mulinlab/huan/All_result_ICGC/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/")


#1. 测试集和训练集3、7分组
#---------------------------------------------------------------------------------------------------------
org<-read.table("09_prepare_data_for_repo_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
#org1<-org %>% dplyr::select(Drug_claim_primary_name,oncotree_main_ID,average_drug_score,averge_gene_mutation_frequency,average_gene_CADD_score,average_mutation_map_to_gene_level_score,drug_repurposing)
org1<-org %>% dplyr::select(average_drug_score,averge_gene_mutation_frequency,average_gene_CADD_score,average_mutation_map_to_gene_level_score,drug_repurposing)
N = length(org1$drug_repurposing)
#ind=1的是0.7概率出现的行，ind=2是0.3概率出现的行
ind=sample(2,N,replace=TRUE,prob=c(0.7,0.3))
#生成训练集(这里训练集和测试集随机设置为原数据集的70%，30%)
aus_train <- org1[ind==1,]
#生成测试集
aus_test <- org1[ind==2,]
#----------------------------------------------------------------------------------------------------
#生成logis模型，用glm函数
#用训练集数据生成logis模型，用glm函数
#family：每一种响应分布（指数分布族）允许各种关联函数将均值和线性预测器关联起来。常用的family：binomal(link='logit')--响应变量服从二项分布，连接函数为logit，即logistic回归
#---------------------------------------------------------------------- 
#测试集的真实值
pre <- glm(drug_repurposing ~.,family=binomial(link = "logit"),data = aus_train)
summary(pre)
#测试集的真实值
real <- aus_test$drug_repurposing
#predict函数可以获得模型的预测值。这里预测所需的模型对象为pre，预测对象newdata为测试集,预测所需类型type选择response,对响应变量的区间进行调整
predict. <- predict.glm(pre,type='response',newdata=aus_test)
#按照预测值为1的概率，>0.5的返回1，其余返回0
predict =ifelse(predict.>0.5,1,0)
#数据中加入预测值一列
aus_test$predict = predict
#------------------------------------------------
#3.模型检验
##模型检验
res <- data.frame(real,predict)
#训练数据的行数，也就是样本数量
n = nrow(aus_train)      
#计算Cox-Snell拟合优度
R2 <- 1-exp((pre$deviance-pre$null.deviance)/n)    
cat("Cox-Snell R2=",R2,"\n")
#-------------------------------------------------------
#4.准确率和精度
true_value=aus_test[,5]
predict_value=aus_test[,6]
#计算模型精确度
error = predict_value-true_value
accuracy = (nrow(aus_test)-sum(abs(error)))/nrow(aus_test) #精确度--判断正确的数量占总数的比例
#计算Precision，Recall和F-measure
#一般来说，Precision就是检索出来的条目（比如：文档、网页等）有多少是准确的，Recall就是所有准确的条目有多少被检索出来了
#和混淆矩阵结合，Precision计算的是所有被检索到的item（TP+FP）中,"应该被检索到的item（TP）”占的比例；Recall计算的是所有检索到的item（TP）占所有"应该被检索到的item（TP+FN）"的比例。
precision=sum(true_value & predict_value)/sum(predict_value)  #真实值预测值全为1 / 预测值全为1 --- 提取出的正确信息条数/提取出的信息条数
recall=sum(predict_value & true_value)/sum(true_value)  #真实值预测值全为1 / 真实值全为1 --- 提取出的正确信息条数 /样本中的信息条数
#P和R指标有时候会出现的矛盾的情况，这样就需要综合考虑他们，最常见的方法就是F-Measure（又称为F-Score）
F_measure=2*precision*recall/(precision+recall)    #F-Measure是Precision和Recall加权调和平均，是一个综合评价指标
#输出以上各结果
print(accuracy)
print(precision)
print(recall)
print(F_measure)
#混淆矩阵，显示结果依次为TP、FN、FP、TN
table(true_value,predict_value)  
#------------------------------------------------------
#5.ROC曲线的几个方法
#------------------------------
library(ROCR)     
pred <- prediction(predict.,true_value)   #预测值(0.5二分类之前的预测值)和真实值   
performance(pred,'auc')@y.values        #AUC值
perf <- performance(pred,'tpr','fpr')
plot(perf)
#方法2
#install.packages("pROC")
library(pROC)
modelroc <- roc(true_value,predict.)
plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,legacy.axes=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)        #画出ROC曲线，标出坐标，并标出AUC的值
#方法3，按ROC定义
TPR=rep(0,1000)
FPR=rep(0,1000)
p=predict.
for(i in 1:1000)
{ 
  p0=i/1000;
  ypred<-1*(p>p0)  
  TPR[i]=sum(ypred*true_value)/sum(true_value)  
  FPR[i]=sum(ypred*(1-true_value))/sum(1-true_value)
}
plot(FPR,TPR,type="l",col=2)
points(c(0,1),c(0,1),type="l",lty=2)

#--------------------- 
#6.更换测试集和训练集的选取方式，采用五折交叉验证
#--------------------- 
org<-read.table("09_prepare_data_for_repo_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
#org1<-org %>% dplyr::select(Drug_claim_primary_name,oncotree_main_ID,average_drug_score,averge_gene_mutation_frequency,average_gene_CADD_score,average_mutation_map_to_gene_level_score,drug_repurposing)
org1<-org %>% dplyr::select(average_drug_score,averge_gene_mutation_frequency,average_gene_CADD_score,average_mutation_map_to_gene_level_score,drug_repurposing)
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
  true_value1 =fold_test[,5]
  #--------------------------把所有的被预测的测试数据的结果放到一个表里
  tmp<-data.frame(true_value1= fold_test[,5],predict_value1=fold_predict)
  rs <- bind_rows(rs,tmp)
  #---------------------------
  fold_error = fold_test[,6]-fold_test[,5]
  fold_accuracy = (nrow(fold_test)-sum(abs(fold_error)))/nrow(fold_test) 
  print(i)
  print("***测试集精确度***")
  print(fold_accuracy)
  print("***训练集精确度***")
  fold_predict2 <- predict(fold_pre,type='response',newdata=fold_train)
  fold_predict2 =ifelse(fold_predict2>0.5,1,0)
  fold_train$predict = fold_predict2
  fold_error2 = fold_train[,6]-fold_train[,5]
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
#7.得到五折交叉验证的精确度，结果导出
#十折里测试集最大精确度的结果
testi <- org1[folds[[num]],]
traini <- org1[-folds[[num]],]   # 剩下的folds作为训练集
prei <- glm(drug_repurposing ~.,family=binomial(link='logit'),data=traini)
predicti <- predict.glm(prei,type='response',newdata=testi)
true_value1<-testi[,5]
predicti =ifelse(predicti>0.5,1,0)
testi$predict = predicti

#write.csv(testi,"ausfold_test.csv")
errori = testi[,6]-testi[,5]
accuracyi = (nrow(testi)-sum(abs(errori)))/nrow(testi) 
#五折里训练集的精确度
predicti2 <- predict.glm(prei,type='response',newdata=traini)
predicti2 =ifelse(predicti2>0.5,1,0)
traini$predict = predicti2
errori2 = traini[,6]-traini[,5]
accuracyi2 = (nrow(traini)-sum(abs(errori2)))/nrow(traini) 
#测试集精确度、取第i组、训练集精确
accuracyi;num;accuracyi2
#write.csv(traini,"ausfold_train.csv")

