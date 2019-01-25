library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)
library(ggpubr)
library(gcookbook)

setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/gdkb_cgi_oncokb_mtctscan_v2/")
org<-read.table("./output/12_mark_positive_rwr.txt",header = T,sep = "\t") %>% as.data.frame()




pdf("./figure/12_rwr_gene_based_prediction_score_compare.pdf",height = 4,width = 5) #把图片存下来
p <- ggplot(org,aes(x=rwr_type,y=predict_value))+geom_boxplot(aes(fill=rwr_type),width=0.3,outlier.colour = NA) #按照标签画图
p
dev.off()

#----------------violin
pdf("./figure/12_rwr_gene_based_prediction_score_compare_violin.pdf",height = 4,width = 5) #把图片存下来
p1 <- ggplot(org,aes(x=rwr_type,y=predict_value))+geom_violin()+geom_boxplot(aes(fill=rwr_type),width=0.2,outlier.colour = NA) #按照标签画图
#p1 <- ggplot(rs,aes(x=proportion,y=value_in_paper))+geom_violin()+geom_boxplot(aes(fill=proportion),width=0.3,outlier.colour = NA)+ #按照标签画图
  
p1
dev.off()
