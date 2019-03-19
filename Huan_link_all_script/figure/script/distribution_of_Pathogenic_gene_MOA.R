library(MASS)
library(dplyr)
library(tidyverse)
library(ggplot2)

setwd("/f/mulinlab/huan/figure/script/")
dit <-"/f/mulinlab/huan/All_result_ICGC/pathogenicity_mutation_cancer"
org<-read_tsv(file.path(dit, "count_number_of_cancer_gene_MOA.txt")) %>%as.data.frame()
#--------------------------------------
org1<-filter(org,MOA != "NA") #筛选MOA 不等于NA的数据
mycolor1<-c("#ff7473","#ffc952","#47b8e0")
setwd("/f/mulinlab/huan/figure/figures/")
pdf("Distribution_of_Pathogenic_gene_MOA_no_NA_number.pdf",height = 3.5,width = 4.8) #把图片存下来
pie(org1$gene_number, labels = org1$gene_number, cex=0.85,col = mycolor1)
legend("topright", c("Oncogene","TSG","Oncogene,TSG"), cex = 0.55, fill = mycolor1)
dev.off()

#-------------------------------------------------------
#mycolor<-c("#c6cfff","#ffd3de","#acdbdf","#8ed6ff")
mycolor<-c("#ff7473","#ffc952","#47b8e0","#34314c")
setwd("/f/mulinlab/huan/figure/figures/")
pdf("Distribution_of_Pathogenic_gene_MOA_number.pdf",height = 3.5,width = 4) #把图片存下来
pie(org$gene_number, labels = org$gene_number, cex=0.85,col = mycolor)
legend("bottomright", c("Oncogene","TSG","Oncogene,TSG","Unclassified "), cex = 0.5, fill = mycolor)
dev.off()

#----------------------------------------------------------
pdf("Distribution_of_Pathogenic_gene_MOA_percentage.pdf",height = 3.5,width = 4) #把图片存下来
pie(org$gene_number, labels = org$percentage, cex=0.85,col = mycolor)
#legend("bottomright", c("GOF","LOF","LOF,GOF","NA"), cex = 0.55, fill = mycolor)
legend("bottomright", c("Oncogene","TSG","Oncogene,TSG","Unclassified "), cex = 0.5, fill = mycolor)
dev.off()