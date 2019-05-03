library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)

setwd("/f/mulinlab/huan/Figure_V2/script/")
dit <-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/"
Non_cancer_drug<-read.table(file.path(dit, "noncancer_drug_type_number.txt"),header = T,sep = "\t") %>% as.data.frame()
Cancer_drug<-read.table(file.path(dit, "cancer_drug_type_number.txt"),header = T,sep = "\t") %>% as.data.frame()
No_indication_drug<-read.table(file.path(dit, "no_indication_drug_type_number.txt"),header = T,sep = "\t") %>% as.data.frame()

Cancer_drug$class <-c("Cancer drug")
Non_cancer_drug$class <-c("Non-cancer drug")
No_indication_drug$class <-c("No indication drug")

org<- bind_rows(Cancer_drug,Non_cancer_drug,No_indication_drug)

org1<-str_replace(org$drug_type,"Biotech","Biotech drug") %>% as.data.frame()
org <- org%>% select(-1)
org <- bind_cols(org1,org) %>% rename("drug_type" = ".")

setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("02_drug_type_bar_in_three_class.pdf",height = 4,width = 6.0) #把图片存下来
p1<-ggplot(org,aes(x=class,y=drug_number, fill = drug_type)) +geom_bar(stat ="identity",width =0.4) #width =0.5 设置条形宽度
p1<-p1+labs(fill = "Drug type") #修改图例名字
p1<-p1+xlab("")+ylab("Number of drug") #修改坐标轴标签的文本
p1<-p1+scale_x_discrete(limits= c("Cancer drug","Non-cancer drug","No indication drug")) #调整坐标轴上的顺序
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),axis.text.x = element_text(size = 10),
                                                axis.line = element_line(colour = "black")) 
p1
dev.off()
