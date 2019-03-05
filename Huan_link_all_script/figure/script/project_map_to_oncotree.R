library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
library(tidyverse)
setwd("/f/mulinlab/huan/figure/script/")
dit <-"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics"
detail<-read_tsv(file.path(dit, "count_detail_tissue_cancer_project.tsv")) %>% as.data.frame()
main<-read.table(file.path(dit, "count_main_cancer_project.txt"),header = T,sep = "\t") %>% as.data.frame()

setwd("/f/mulinlab/huan/figure/figures/")
pdf("Project_map_to_oncotree_term_of_detail.pdf",height = 5,width = 5) #把图片存下来
p1<- ggplot(detail,aes(x=project_number,y=reorder(cancer,X=project_number))) + geom_point(colour = "#448ef6",size=0.8) #对y按照x对进行排序
p1<-p1+xlab("ICGC project number")+ylab("Oncotree term of detail") #修改坐标轴标签的文本
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),axis.text.y = element_text(size = 5,color="black"),
                                                axis.line = element_line(colour = "black")) #去背景
p1
dev.off()


pdf("Project_map_to_oncotree_term_of_main.pdf",height = 3.5,width = 4) #把图片存下来
#p2<- ggplot(main,aes(x=project_number,y= cancer)) + geom_point(colour = "#448ef6",size=0.8)
p2<- ggplot(main,aes(x=project_number,y=reorder(cancer,X=project_number))) + geom_point(colour = "#448ef6",size=0.8) #对y按照x对进行排序
p2<-p2+xlab("ICGC project number")+ylab("Oncotree term of main") #修改坐标轴标签的文本
p2<-p2+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),axis.text.y = element_text(size = 8,color="black"),
                                                axis.line = element_line(colour = "black")) #去背景
p2
dev.off()
