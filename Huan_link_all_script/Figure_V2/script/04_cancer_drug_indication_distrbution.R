library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
setwd("/f/mulinlab/huan/Figure_V2/script/")
dit <-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/"

org<-read.table(file.path(dit, "indication_contains_drug_number.txt"),header = T,sep = "\t") %>% as.data.frame()

setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("04_cancer_drug_indication_distrbution.pdf",height = 3.5,width = 4.5) #把图片存下来
p1<-ggplot(org,aes(x=Drug_number,y=reorder(Indication_oncotree_ID,Drug_number)))+geom_point(size = 1)
p1<-p1+ylab("Indication oncotree main term")+xlab("Number of drug") #修改坐标轴标签的文本
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                                panel.background = element_blank(), axis.title.y = element_text(size = 10),
                                                axis.title.x = element_text(size = 10),axis.text.x = element_text(size = 7,colour = "black"),
                                                axis.text.y = element_text(size = 7,colour = "black"),
                                                axis.line = element_line(colour = "black")) #去背景
p1
dev.off()