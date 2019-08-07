library(Rcpp)
library(dplyr)
library(ggplot2)
library(readr)
library(pROC)

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V6/validation/27354694_TCGA/output/")
org<-read_tsv("./11_prediction_and_icgc_result.txt",col_names = T )%>%as.data.frame()
#----------------------------

pdf("../figure/ROC_of_validation_Complete_new.pdf",height = 4,width = 5)
# pdf("../figure/ROC_of_validation_Complete_Partial.pdf",height = 4,width = 5)
modelroc <- roc(org$pairs_type,org$predict_value,direction=  "<")
plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,legacy.axes=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue")        #画出ROC曲线，标出坐标，并标出AUC的值 #print.thres=TRUE 是输出约旦系数
dev.off()


#-----------------------------
library(plotROC)
# pdf("../figure/ROC_of_validation_Complete_new.pdf",height = 4,width = 5)
# pdf("../figure/ROC_of_validation_Complete_Partial_new.pdf",height = 4,width = 5)
# pdf("../figure/ROC_of_validation_Complete_Progressive_new.pdf",height = 4,width = 5)
pdf("../figure/ROC_of_validation_Complete_Partial_Progressive_new.pdf",height = 4,width = 5)
p1 <- ggplot(org, aes(d = pairs_type, m = predict_value)) + geom_roc(color="#448ef6",n.cuts = 0)
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
# orgn=org[c('pairs_type','predict_value')]
# orgn[orgn$pairs_type==0,1]=2
# orgn[orgn$pairs_type==1,1]=0
# orgn[orgn$pairs_type==2,1]=1
#-----------------------------------------------

pred <- prediction(org$predict_value,org$pairs_type)   #预测值(0.5二分类之前的预测值)和真实值
performance(pred,'auc')@y.values        #AUC值
perf <- performance(pred,'tpr','fpr')