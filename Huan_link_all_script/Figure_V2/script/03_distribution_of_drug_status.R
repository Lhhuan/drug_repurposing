library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
setwd("/f/mulinlab/huan/Figure_V2/script/")
dit <-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/"
non_cancer_drug<-read.table(file.path(dit, "noncancer_drug_status_number.txt"),header = T,sep = "\t") %>% as.data.frame()
cancer_drug<-read.table(file.path(dit, "cancer_drug_status_number.txt"),header = T,sep = "\t") %>% as.data.frame()
cancer_drug$class <-c("Cancer drug")
non_cancer_drug$class <-c("Non-cancer drug")
org<- bind_rows(cancer_drug,non_cancer_drug)
org$drug_status = factor(org$drug_status, levels=c("FDA approved","Clinical Trials", "Experimental"))
setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("03_distribution_of_drug_status_Cumulative.pdf",height = 3.5,width = 5.5) #把图片存下来
p1<-ggplot(org,aes(x=class,y=drug_number, fill = drug_status)) +geom_bar(stat ="identity",width =0.3) #width =0.5 设置条形宽度
# p1<-p1+scale_fill_manual(values =c("#a0edf7","#8ed6ff","#ffe3b0","#ffc1c8", "#ffcece", "#e8d3ff","#c6cfff","#deecff") )
p1<-p1+labs(fill = "Drug status") #修改图例名字
#p1<-p1+scale_fill_discrete(limits= c("FDA approved","Phase 4", "Phase 3","Phase 2","Phase 1","Phase 0",""Preclinical","Unknown")) #修改图例顺序
p1<-p1+xlab("")+ylab("Number of drug") #修改坐标轴标签的文本
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),axis.text.x = element_text(size = 10),
                                                axis.line = element_line(colour = "black")) #去背景
p1
dev.off()
