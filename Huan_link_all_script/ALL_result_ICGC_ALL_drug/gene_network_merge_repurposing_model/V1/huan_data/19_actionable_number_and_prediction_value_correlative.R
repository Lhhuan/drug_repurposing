library(gcookbook)
library(dplyr)
library(ggplot2)
library(readr)
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/huan_data/")
org<-read_tsv("./output/18_actionable_number_and_prediction_value.txt",col_names = T )%>%as.data.frame()

# pdf("mutation_occurance_cutoff.pdf",height = 3.5,width = 4)
p1<-ggplot(BOD1, aes(x=actionable_mutation_number, y=predict_value, group=1)) + geom_line(linetype="solid", color ="#4a9ff5") +geom_point(size=0.6, color ="#4a9ff5" )
p2<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 13),axis.title.x = element_text(size = 13),axis.line = element_line(colour = "black")) 
p2<-p2+xlab("Actionable mutation number") + ylab("Predict value")
p2
# dev.off()
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/huan_data/figure")
pdf("19_actionable_number_and_prediction_value_correlative.pdf",height = 3.5,width = 4)
p1<-ggplot(org,aes(x=actionable_mutation_number, y=predict_value))+geom_point(size=0.2, color ="grey60" )
p1<-p1+stat_smooth(method = lm,level=0.99,colour ="black",size=0.3)
p1<-p1+coord_cartesian(ylim = c(0,1))     
p1<-p1+xlab("Actionable mutation number") + ylab("Predict value")
p1<-p1+theme(panel.grid =element_blank())+ #修改背景
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), 
        panel.background = element_blank(),
        axis.title.y = element_text(size = 13),
        axis.title.x = element_text(size = 13),
        axis.line = element_line(colour = "black")) #修改背景
p1
dev.off()
#----------------------------------------------------------------
# 
# p2<-ggplot(org,aes(x=actionable_mutation_number, y=predict_value))+geom_point(size=0.2, color ="grey60" )
# p2<-p2+scale_x_log10(breaks =5^(0:3))
# p2<-p2+stat_smooth(method = lm,level=0.99,colour ="black",size=0.3)
# p2
