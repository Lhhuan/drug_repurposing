library(gcookbook)
library(dplyr)
library(ggplot2)
library(readr)
setwd("/f/mulinlab/huan/figure/figures/")

BOD1<-read_tsv("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/occur_num.txt",col_names = T )%>%as.data.frame()

pdf("mutation_occurance_cutoff.pdf",height = 4,width = 5)
p1<-ggplot(BOD1, aes(x=occurthan, y=num, group=1)) + geom_line(linetype="solid") +geom_point(size=1)
p2<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15),axis.line = element_line(colour = "black")) 
p2
dev.off()
