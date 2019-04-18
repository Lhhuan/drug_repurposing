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
main<-main_cancer%>%filter(p.value<1)
detail<-detail_cancer%>%filter(p.value<1) #p<0.00001
main<-main%>%dplyr::rename(conf_left= p_t_main.conf.int.1.)
main<-main%>%dplyr::rename(conf_right= p_t_main.conf.int.2.)
main$conf_left<-main$conf_left *100
main$conf_right<-main$conf_right *100

detail<-detail%>%dplyr::rename(conf_left=p_t_d.conf.int.1.)
detail<-detail%>%dplyr::rename(conf_right=p_t_d.conf.int.2.)
detail$conf_left<-detail$conf_left *100
detail$conf_right<-detail$conf_right *100
main_than_0<-main%>%filter(final_percentage>0)%>%arrange(final_percentage)
detail_than_0<-detail%>%filter(final_percentage>0)%>%arrange(final_percentage) #先排好序，方便后面画图

#-------------------------------------------------

credplot.gg <- function(d){
  p1<-ggplot(data=d, aes(x=Cancer_term,y=final_percentage, ymin=conf_left , ymax=conf_right))
  p1<-p1+geom_pointrange(size = 0.3) 
  p1<-p1+coord_flip()# +  # flip coordinates (puts labels on y axis)
  p1<-p1+ylab("Drug cancer pairs with associations(%)")+xlab("Oncotree term of detail") #修改坐标轴标签的文本
  p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                                  panel.background = element_blank(), axis.title.y = element_text(size = 11.5),
                                                  axis.title.x = element_text(size = 11.5),axis.text.y = element_text(size = 6,color="black"),
                                                  axis.line = element_line(colour = "black")) #去背景
  return(p1)
}

setwd("/f/mulinlab/huan/figure/figures/")
pdf("Gene_based_drug_detail_cancer_pairs_with_genetic_associations_percentage_than0.pdf",height = 4.5,width = 5.2) #把图片存下来
detail_than_0$Cancer_term <- factor(detail_than_0$Cancer_term, levels=detail_than_0$Cancer_term) #对Cancer_term进行排序
p<-credplot.gg(detail_than_0)
p
dev.off()

#--------------------------------------------------
#-----------------------------------------------------------------------------

credplot.gg_main <- function(d){
  p1<-ggplot(data=d, aes(x=Cancer_term,y=final_percentage, ymin=conf_left , ymax=conf_right))
  p1<-p1+geom_pointrange(size = 0.3) 
  p1<-p1+coord_flip()# +  # flip coordinates (puts labels on y axis)
  p1<-p1+ylab("Drug cancer pairs with associations(%)")+xlab("Oncotree term of main") #修改坐标轴标签的文本
  p1<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                                panel.background = element_blank(), axis.title.y = element_text(size = 11.5),
                                                axis.title.x = element_text(size = 11),axis.text.y = element_text(size = 8,color="black"),
                                                axis.line = element_line(colour = "black")) #去背景
  return(p1)
}

setwd("/f/mulinlab/huan/figure/figures/")
pdf("Gene_based_drug_main_cancer_pairs_with_genetic_associations_percentage_large_than_0.pdf",height = 3.2,width = 4.6) #把图片存下来
main_than_0$Cancer_term <- factor(main_than_0$Cancer_term, levels=main_than_0$Cancer_term) #对Cancer_term进行排序
p<-credplot.gg_main(main_than_0)
p
dev.off()





