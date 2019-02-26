library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
setwd("/f/mulinlab/huan/figure/script/")
dit <-"/f/mulinlab/huan/All_result_ICGC/"
non_cancer_drug<-read.table(file.path(dit, "noncancer_drug_type_number.txt"),header = T,sep = "\t") %>% as.data.frame()
cancer_drug<-read.table(file.path(dit, "cancer_drug_type_number.txt"),header = T,sep = "\t") %>% as.data.frame()

cancer_drug$class <-c("Cancer drug")
non_cancer_drug$class <-c("Non-cancer drug")
org<- bind_rows(cancer_drug,non_cancer_drug)
org1<-str_replace(org$drug_type,"Biotech","Biotech drug") %>% as.data.frame()
org <- org%>% select(-1)
org <- bind_cols(org1,org) %>% rename("drug_type" = ".")

setwd("/f/mulinlab/huan/figure/figures/")
pdf("distribution_of_drug_type_Cumulative.pdf",height = 3.5,width = 4.5) #把图片存下来
p1<-ggplot(org,aes(x=class,y=drug_number, fill = drug_type)) +geom_bar(stat ="identity",width =0.4) #width =0.5 设置条形宽度
p1<-p1+labs(fill = "Drug type") #修改图例名字
# p1<-p1+scale_fill_manual(values =c("#ffc1c8","#ffe3b0", "#8ed6ff") ) #自动添加颜色
p1<-p1+xlab("Drug classify by cancer")+ylab("Number of mutation") #修改坐标轴标签的文本
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),axis.text.x = element_text(size = 10),
                                                axis.line = element_line(colour = "black")) 
p1
dev.off()
