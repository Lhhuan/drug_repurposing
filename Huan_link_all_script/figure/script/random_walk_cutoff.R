library(MASS)
library(dplyr)
library(tidyverse)
library(ggplot2)

setwd("/f/mulinlab/huan/figure/figures/")
f<-read_tsv("/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/parameter_optimization/top/hit_result/02_cutoff_p_significant_count.txt",col_names = T)%>%as.data.frame()
f$hl <- "no"  # Set all to 'no
f$hl[f$cutoff == "0.044"] <- "yes"  # If group is 'trt2', set to 'yes'


pdf("random_walk_cutoff.pdf",height = 4,width = 5)
p1<-ggplot(f, aes(x=cutoff, y=recall_percentage)) + geom_point(colour = "#448ef6",size=0.5,shape=16)#基础画图

p2<-p1+scale_x_continuous(limits=c(0,0.1),breaks=seq(0,0.1,0.01))##修改坐标的显示刻度
p3<-p2+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15),axis.line = element_line(colour = "black"))
#去背景，调坐标轴
p4<-p3+annotate(geom="text", x=0.044, y=73.9, label="(0.044,73.9)", color="black",size = 5)
p4<-p4+ylab("Recall ratio of drug disease pairs(%)")+xlab("Cutoff") #修改坐标轴标签的文本
p4
dev.off()
#-----------------------------------------------------------------------
pdf("random_walk_cutoff_segment.pdf",height = 4,width = 5)
p1<-ggplot(f, aes(x=cutoff, y=recall_percentage)) + geom_point(colour = "#448ef6",size=0.5,shape=16)#基础画图
p2<-p1+scale_x_continuous(limits=c(0,0.1),breaks=seq(0,0.1,0.01))##修改坐标的显示刻度
p3<-p2+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15),axis.line = element_line(colour = "black"))
#去背景，调坐标轴
p4<-p3+annotate(geom="text", x=0.044, y=73.9, label="(0.044,73.9)", color="black",size = 5)
p4<-p4+ylab("Recall ratio of drug disease pairs(%)")+xlab("Cutoff") #修改坐标轴标签的文本
p4<-p4+annotate("segment", x = 0, xend = 0.044, y = 73.9, yend = 73.9,colour = "grey") #加竖线 #有416个特别高的
p4<-p4+annotate("segment", x = 0.044, xend = 0.044, y = 0, yend = 73.9,colour = "grey") #加竖线 #有416个特别高的
p4
dev.off()

# p1<-ggplot(f, aes(x=cutoff, y=recall_percentage)) + geom_point(size=0.5,shape=16)#基础画图
# p1<-p1+scale_colour_manual(values = c("grey85", 
#                                     "red"), guide = FALSE)






# # 要想高亮某一个元素，或者几个元素，
# # 先新建一个变量，然后对要高亮的部分赋予不同的值
# pg <- PlantGrowth  # Make a copy of the PlantGrowth data
# pg$hl <- "no"  # Set all to 'no'
# pg$hl[pg$group == "trt2"] <- "yes"  # If group is 'trt2', set to 'yes'
# 
# 
# ggplot(pg, aes(x = group, y = weight, fill = hl)) + geom_boxplot() + scale_fill_manual(values = c("grey85", 
#                                                                                                   "#FFDDCC"), guide = FALSE)