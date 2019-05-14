library(Rcpp)
library(dplyr)
library(ggplot2)
library(readr)
library(pROC)

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/validation/gdkb_cgi_oncokb_mtctscan/")
org<-read_tsv("./output/08_Independent_sample_repurposing.txt",col_names = T )%>%as.data.frame()
#----------------------------

pdf("./figure/ROC_of_validation.pdf",height = 4,width = 5)
modelroc <- roc(org$sample_type,org$predict_value)
plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,legacy.axes=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue")        #画出ROC曲线，标出坐标，并标出AUC的值 #print.thres=TRUE 是输出约旦系数
dev.off()
