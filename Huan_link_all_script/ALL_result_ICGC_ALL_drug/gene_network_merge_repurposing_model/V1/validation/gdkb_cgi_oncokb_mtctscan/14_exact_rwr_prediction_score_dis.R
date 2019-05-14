library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)
library(ggpubr)
library(gcookbook)

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/validation/gdkb_cgi_oncokb_mtctscan/")
org<-read.table("./output/13_positive_sample_repurposing.txt",header = T,sep = "\t") %>% as.data.frame()




pdf("./figure/13_rwr_gene_based_prediction_score_compare.pdf",height = 4,width = 5) #把图片存下来
p <- ggplot(org,aes(x=rwr_type,y=predict_value))+geom_boxplot(aes(fill=rwr_type),width=0.3,outlier.colour = NA) #按照标签画图
p
dev.off()

#----------------violin
pdf("./figure/13_rwr_gene_based_prediction_score_compare_violin.pdf",height = 4,width = 5) #把图片存下来
p1 <- ggplot(org,aes(x=rwr_type,y=predict_value))+geom_violin()+geom_boxplot(aes(fill=rwr_type),width=0.2,outlier.colour = NA) #按照标签画图
#p1 <- ggplot(rs,aes(x=proportion,y=value_in_paper))+geom_violin()+geom_boxplot(aes(fill=proportion),width=0.3,outlier.colour = NA)+ #按照标签画图
  
p1
dev.off()
