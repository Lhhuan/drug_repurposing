library(MASS)
library(dplyr)
library(ggplot2)

setwd("/f/mulinlab/huan/figure/figures/")
f<-read_tsv("/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/parameter_optimization/top/hit_result/02_cutoff_p_significant_count.txt",col_names = T)%>%as.data.frame()
#layer1=ggplot(f, aes(x=cutoff, y=drug_repo_count)) + geom_point(size=0.8,shape=16)+scale_x_continuous(limits=c(0,0.1),breaks=seq(0,0.1,0.01))+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15),axis.line = element_line(colour = "black"))
pdf("random_walk_cutoff.pdf",height = 4,width = 5)
p1=ggplot(f, aes(x=cutoff, y=drug_repo_count)) + geom_point(colour = "#448ef6",size=0.5,shape=16)#基础画图
p2<-p1+scale_x_continuous(limits=c(0,0.1),breaks=seq(0,0.1,0.01))##修改坐标的显示刻度
p3<-p2+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15),axis.line = element_line(colour = "gray")) 
#去背景，调坐标轴
p4<-p3+annotate(geom="text", x=0.044, y=185, label="(0.044,185)", color="black",size = 5)
p4<-p4+ylab("Recall number of drug disease pairs")+xlab("Cutoff") #修改坐标轴标签的文本
p4
dev.off()
