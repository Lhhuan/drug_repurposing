library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
setwd("/f/mulinlab/huan/Figure_V2/script/")
dit <-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/"

org<-read.table(file.path(dit, "drug_number_of_target_number.txt"),header = T,sep = "\t") %>% as.data.frame()

setwd("/f/mulinlab/huan/Figure_V2/figures/")

pdf("05_distribution_of_drug_target.pdf",height = 3.5,width = 4)
p1<-ggplot(org, aes(x=Target_number, y=Drug_number, group=1)) + geom_line(linetype="solid", color ="#4a9ff5") +geom_point(size=0.6, color ="#4a9ff5" )
p2<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 13),axis.title.x = element_text(size = 13),axis.line = element_line(colour = "black")) 
p2<-p2+xlab("Target number") + ylab("Drug number")
p2
dev.off()

org1<-read.table(file.path(dit, "drug_target_number.txt"),header = T,sep = "\t") %>% as.data.frame()

pdf("05_distribution_of_drug_target_density.pdf",height = 3.5,width = 4) #把图片存下来
p1<-ggplot(org1,aes(x=target_number)) + geom_density(color= "#448ef6")+ xlab("Number of Drug target")+ylab("Density")
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),
                                                axis.line = element_line(colour = "black")) #去背景
p1
dev.off()