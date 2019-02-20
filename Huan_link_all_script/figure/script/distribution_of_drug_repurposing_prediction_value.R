library(MASS)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)

setwd("/f/mulinlab/huan/figure/script/")
dit <-"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/huan_data/output"
repo<-read_tsv(file.path(dit, "15_drug_potential_repurposing.txt")) %>%as.data.frame()
Drug_cancer_ID <- rownames(repo)
rownames(repo) <- NULL
repo <- cbind(Drug_cancer_ID,repo)
repo1<-repo%>%arrange(desc(predict_value))#降序排序

setwd("/f/mulinlab/huan/figure/figures/")
pdf("distribution_of_Drug_repurposing_predicted_value.pdf",height = 3.5,width = 4) #把图片存下来
p1<-ggplot(repo1,aes(x=predict_value)) + geom_density(color= "#448ef6")+ xlab("Drug repurposing predicted value")
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 10),
                                                axis.title.x = element_text(size = 10),
                                                axis.line = element_line(colour = "gray")) #去背景
p1
dev.off()

#repo_value<-filter(repo1, abs(predict_value - 0.9999)<0.0000001 )%>%dplyr::rename("score" = "score_lable")%>%as.data.frame()

repo_value<-filter(repo1, predict_value>0.9)%>%dplyr::rename("score" = "score_lable")%>%as.data.frame()

setwd("/f/mulinlab/huan/figure/figures/")
pdf("Top_Drug_repurposing_predicted_value.pdf",height = 3.5,width = 4) #把图片存下来
p2<-ggplot(repo_value,aes(x=reorder(Drug_cancer_ID,X=predict_value),y=predict_value)) + geom_point(size = 0.1,color= "#448ef6") #对x按照y对进行排序
p2 <- p2 + theme(axis.text.x=element_blank(), axis.ticks.x=element_blank()) #不显示x轴上的刻度
p2<-p2+xlab("Drug cancer pairs")+ylab("Drug repurposing predicted value")
p2<-p2 + annotate("segment", x = 643, xend = 643, y = 0.9, yend = 1,colour = "#a1dd70") #加竖线 #有416个特别高的
p2<-p2+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 11),
                                                axis.title.x = element_text(size = 11),
                                                axis.line = element_line(colour = "gray")) #去背景
p2
dev.off()

 #p2<- p2+geom_text(aes(label=pairs),size =2,color ="black") 加文本标签
