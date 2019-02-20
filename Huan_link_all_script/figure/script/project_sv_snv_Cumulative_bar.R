library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
setwd("/f/mulinlab/huan/figure/script/")
dit <-"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot"
translocation<-read.table(file.path(dit, "project_pathogenic_hotspot_tra.txt"),header = T,sep = "\t") %>% as.data.frame()
inversion<-read.table(file.path(dit, "project_pathogenic_hotspot_inv.txt"),header = T,sep = "\t") %>% as.data.frame()
cnv<-read.table(file.path(dit, "project_pathogenic_hotspot_cnv.txt"),header = T,sep = "\t") %>% as.data.frame()
deletion<-read.table(file.path(dit, "project_pathogenic_hotspot_del.txt"),header = T,sep = "\t") %>% as.data.frame()
duplication<- read.table(file.path(dit, "project_pathogenic_hotspot_dup.txt"),header = T,sep = "\t") %>% as.data.frame()
snv <-read.table("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/project_pathogenicity_mutation_number.txt",header = T,sep = "\t")
snv<-snv%>%dplyr::rename(number_of_hotspot=mutation_number)%>% as.data.frame()

cnv$class <-c("cnv")
snv$class <-c("snv")
translocation$class <-c("translocation")
inversion$class <-c("inversion")
deletion$class <-c("deletion")
duplication$class <-c("duplication")
org<- bind_rows(translocation,inversion,cnv,deletion,duplication,snv)
setwd("/f/mulinlab/huan/figure/figures/")
pdf("project_mutation_Cumulative.pdf",height = 3.5,width = 7) #把图片存下来
p1<-ggplot(org,aes(x=project,y=number_of_hotspot, fill = class)) +geom_bar(stat ="identity")
p1<-p1+xlab("Project")+ylab("Mumber of mutation") #修改坐标轴标签的文本
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),axis.text.x = element_text(size = 5.5,angle=90,color="black"),
                                                axis.line = element_line(colour = "gray")) #去背景,把横坐标转90度，并设置字体
p1
dev.off()
