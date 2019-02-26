library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
library(tidyverse)
setwd("/f/mulinlab/huan/figure/script/")
dit <-"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/huan_data/output/"

main_cancer<-read_tsv(file.path(dit, "gene_based_main_cancer_proportion_test_top.txt")) %>% as.data.frame()
detail_cancer<-read_tsv(file.path(dit, "gene_based_detail_cancer_proportion_test_top.txt")) %>% as.data.frame()
main<-main_cancer%>%filter(p.value<0.00001)
detail<-detail_cancer%>%filter(p.value<0.00001) #p<0.00001
main<-main%>%dplyr::rename(conf_left= p_t_main.conf.int.1.)
main<-main%>%dplyr::rename(conf_right= p_t_main.conf.int.2.)
main$conf_left<-main$conf_left *100
main$conf_right<-main$conf_right *100

detail<-detail%>%dplyr::rename(conf_left=p_t_d.conf.int.1.)
detail<-detail%>%dplyr::rename(conf_right=p_t_d.conf.int.2.)
detail$conf_left<-detail$conf_left *100
detail$conf_right<-detail$conf_right *100
main_than_0<-main%>%filter(final_percentage>0)
detail_than_0<-detail%>%filter(final_percentage>0)

#--------------------------------------
setwd("/f/mulinlab/huan/figure/figures/")
#pdf("Gene_based_drug_detail_cancer_pairs_with_genetic_associations_percentage.pdf",height = 4.5,width = 7) #把图片存下来
#p1<-ggplot(data=detail, aes(x=Cancer_term,y=reorder(Cancer_term,X=final_percentage,conf_left,conf_right), ymin=conf_left , ymax=conf_right))
credplot.gg <- function(d){
p1<-ggplot(data=d, aes(x=Cancer_term,y=final_percentage, ymin=conf_left , ymax=conf_right))
p1<-p1+geom_pointrange(colour="#2f89fc") 
p1<-p1+coord_flip()# +  # flip coordinates (puts labels on y axis)
p1<-p1+ylab("Drug cancer pairs with genetic associations(%)")+xlab("Oncotree term of detail") #修改坐标轴标签的文本
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                                panel.background = element_blank(), axis.title.y = element_text(size = 11.5),
                                                axis.title.x = element_text(size = 11.5),axis.text.y = element_text(size = 5,color="black"),
                                                axis.line = element_line(colour = "black")) #去背景
return(p1)
}

credplot.gg(detail)

detail$Cancer_term <- factor(detail$Cancer_term, levels=rev(detail$final_percentage))
credplot.gg(d)

#dev.off()
#--------------------------------------------------
p1<-ggplot(data=detail, aes(x=Cancer_term,y=final_percentage, ymin=conf_left , ymax=conf_right))
p1<-p1+geom_pointrange(colour="#2f89fc") 
p1<-p1+coord_flip()# +  # flip coordinates (puts labels on y axis)
p1<-p1+ylab("Drug cancer pairs with genetic associations(%)")+xlab("Oncotree term of detail") #修改坐标轴标签的文本
p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                                panel.background = element_blank(), axis.title.y = element_text(size = 11.5),
                                                axis.title.x = element_text(size = 11.5),axis.text.y = element_text(size = 5,color="black"),
                                                axis.line = element_line(colour = "black")) #去背景
