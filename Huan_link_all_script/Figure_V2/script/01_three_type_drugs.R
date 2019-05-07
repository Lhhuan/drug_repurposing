library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)

setwd("/f/mulinlab/huan/Figure_V2/script/")
dit <-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/"
org<-read_tsv(file.path(dit, "three_type_drug_type_number.txt")) %>%as.data.frame()
org$Drug_type = factor(org$Drug_type, levels=c("Cancer drug","Non-cancer drug", "No indication drug"))

setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("01_three_type_drug_number_bar_plot.pdf",height = 3.5,width = 4) #把图片存下来
p1<-ggplot(org,aes(x=Drug_type,y=Drug_number)) +geom_bar(stat = "identity",fill = "#448ef6",width =0.4)
p1<-p1+xlab("Drug type")+ylab("Drug number")
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                       panel.background = element_blank(), 
                                                       axis.text.y = element_text(color="black"),
                                                       axis.line = element_line(colour = "black")) #去背景
p1
dev.off()

mycolor<-c("#f9c00c","#00b9f1","#f9320c")
setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("01_three_type_drug_number_pie.pdf",height = 3.5,width = 4) #把图片存下来
pie(org$Drug_number, labels = org$Drug_number, cex=0.85,col = mycolor)
legend("bottomright", c("Cancer drug","Non-cancer drug","No indication drug"), cex = 0.48, fill = mycolor)
dev.off()
