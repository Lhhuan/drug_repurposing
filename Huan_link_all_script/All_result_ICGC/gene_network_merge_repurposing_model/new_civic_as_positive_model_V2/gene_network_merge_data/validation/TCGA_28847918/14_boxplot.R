library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)


setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/")
#org<-read.table("./output/11_prediction_and_icgc_result.txt",header = T,sep = "\t") %>% as.data.frame()
out<-read.table("./output/14_paper_drug_cancer_out_Positive_sample.txt",header = T,sep = "\t") %>% as.data.frame()%>%dplyr::select(predict_value)
overlap<-read.table("./output/14_paper_drug_cancer_overlap_with_Positive_sample.txt",header = T,sep = "\t") %>% as.data.frame()%>%dplyr::select(predict_value)

out$class <- c("out_civic")
overlap$class <- c("overlap_civic") #加标签
rs<- bind_rows(overlap,out)
p <- ggplot(rs,aes(x=class,y=predict_value))+geom_boxplot(aes(fill=class),width=0.5) #按照标签画图
p
