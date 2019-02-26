library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)

setwd("/f/mulinlab/huan/figure/script/")

org<-read.table("/f/mulinlab/huan/figure/output_data/all_mutation_Pathogenicity.txt",header = T,sep = "\t") %>% as.data.frame()
setwd("/f/mulinlab/huan/figure/figures/")
pdf("all_mutation_Pathogenicity.pdf",height = 3.5,width = 5) #把图片存下来
p1 <-ggplot (org,aes(x=Pathogenicity_score,colour = Source)) +geom_density(alpha=.2) + xlab("Pathogenicity score") #alpha设置透明度
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),
                                                axis.line = element_line(colour = "black")) #去背景
p1<-p1+ylab("Density")
p1<-p1+scale_colour_discrete(breaks= c("SNV/Indel","CNV", "Deletion","Duplication","Inversion","Translocation")) #修改图例顺序
p1<-p1+labs(colour = "Class") #修改图例名字
p1
dev.off()

#rename(translocation,"Pathogenicity_score"="SVSCORETOP10")

