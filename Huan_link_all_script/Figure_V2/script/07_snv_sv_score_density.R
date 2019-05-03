library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
library(readr)
setwd("/f/mulinlab/huan/Figure_V2/script/")
dit <-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/pathogenicity_mutation_cancer/output/"

org<-read_tsv(file.path(dit, "merge_P_snv_sv.txt"))
org1<-org %>% dplyr::select(Score,ID,Source)%>%unique()
org2<-org %>% dplyr::select(occurance,ID,Source)%>%unique()

setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("07_snv_sv_score_density.pdf",height = 3.5,width = 5)
p1 <-ggplot (org1,aes(x=Score,colour = Source)) +geom_density(alpha=.2) + xlab("Pathogenicity score") #alpha设置透明度
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),
                                                axis.line = element_line(colour = "black")) #去背景
p1<-p1+ylab("Density")
p1<-p1+scale_colour_discrete(breaks= c("SNV/Indel","CNV", "Deletion","Duplication","Inversion","Translocation")) #修改图例顺序
p1<-p1+labs(colour = "Class") #修改图例名字
p1
dev.off()

setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("07_snv_sv_occur_density.pdf",height = 3.5,width = 5)
p1 <-ggplot (org2,aes(x=occurance,colour = Source)) +geom_density(alpha=.2) + xlab("Pathogenicity score") #alpha设置透明度
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),
                                                axis.line = element_line(colour = "black")) #去背景
p1<-p1+ylab("Density")
p1<-p1+scale_colour_discrete(breaks= c("SNV/Indel","CNV", "Deletion","Duplication","Inversion","Translocation")) #修改图例顺序
p1<-p1+labs(colour = "Class") #修改图例名字
p1
dev.off()


org3<-org2[org2$Source!="Translocation",]
org4<-org3[org3$Source!="Inversion",]

setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("07_snv_sv_out_of_Translocation_occur_density.pdf",height = 3.5,width = 5)
p1<-p1+scale_colour_discrete(breaks= c("SNV/Indel","CNV", "Deletion","Duplication","Inversion")) #修改图例顺序
p1<-p1+labs(colour = "Class") #修改图例名字
p1
dev.off()


