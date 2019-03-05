library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
setwd("/f/mulinlab/huan/figure/script/")
dit <-"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_snv_and_sv/output/"
all_mutation<-read.table(file.path(dit, "snv_sv_number_in_cancer.txt"),header = T,sep = "\t") %>% as.data.frame()
snv<-all_mutation%>%filter(Class=="SNV/Indel")%>% as.data.frame()%>%arrange(desc(mutation_number))

#snv<-snv%>%dplyr::rename(number_of_hotspot=mutation_number)%>% as.data.frame()
#-------------------------------------------------------------------------
setwd("/f/mulinlab/huan/figure/figures/")
pdf("main_cancer_snv_indel_mutation_Cumulative.pdf",height = 5,width = 7) #把图片存下来
p1<-ggplot(all_mutation,aes(x=oncotree_ID_main_tissue,y=mutation_number, fill = Class)) +geom_bar(stat ="identity")
p1<-p1+xlab("Main cancer")+ylab("Number of mutation") #修改坐标轴标签的文本
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 13),
                                                axis.title.x = element_text(size = 13),axis.text.x = element_text(size = 8,color="black"),
                                                axis.line = element_line(colour = "black")) #去背景,把横坐标转90度，并设置字体
p1<-p1+scale_fill_discrete(limits= c("SNV/Indel","CNV", "Deletion","Duplication","Inversion","Translocation")) #修改图例顺序
p1<-p1+coord_flip() #交换x轴和y轴
p1
dev.off()
#----------------------------------------------------------------
# setwd("/f/mulinlab/huan/figure/figures/")
# pdf("main_cancer_mutation_Cumulative.pdf",height = 5,width = 7) #把图片存下来
# p1<-ggplot(all_mutation,aes(x=oncotree_ID_main_tissue,y=mutation_number, fill = Class)) +geom_bar(stat ="identity")
# p1<-p1+xlab("Main cancer")+ylab("Number of mutation") #修改坐标轴标签的文本
# p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
#                                                 panel.background = element_blank(), axis.title.y = element_text(size = 13),
#                                                 axis.title.x = element_text(size = 13),axis.text.x = element_text(size = 8,angle=90,color="black"),
#                                                 axis.line = element_line(colour = "black")) #去背景,把横坐标转90度，并设置字体
# p1<-p1+scale_fill_discrete(limits= c("SNV/Indel","CNV", "Deletion","Duplication","Inversion","Translocation")) #修改图例顺序
# p1
# dev.off()
#-------------------------------------------------------------------
pdf("main_cancer_snv_indel.pdf",height = 5,width = 7) #把图片存下来
p2<-ggplot(snv,aes(x=oncotree_ID_main_tissue,y=mutation_number)) +geom_bar(stat ="identity",fill = "#2f89fc") #按照y对x进行排序
p2<-ggplot(snv,aes(x=reorder(oncotree_ID_main_tissue,X = mutation_number),y=mutation_number)) +geom_bar(stat ="identity",fill = "#2f89fc") #按照y对x进行降序排列
p2<-p2+xlab("Main cancer")+ylab("Number of mutation") #修改坐标轴标签的文本
p2<-p2+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 12),
                                                axis.title.x = element_text(size = 12),axis.text.x = element_text(size = 7,color="black"),
                                                axis.line = element_line(colour = "black")) #去背景,把横坐标转90度，并设置字体
p2<-p2+coord_flip() #交换x轴和y轴
p2
dev.off()
