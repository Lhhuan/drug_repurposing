library(gcookbook)
library(dplyr)
library(ggplot2)
library(readr)
setwd("/f/mulinlab/huan/figure/figures/")

BOD1<-read_tsv("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/occur_num.txt",col_names = T )%>%as.data.frame()

pdf("mutation_occurance_cutoff.pdf",height = 3.5,width = 4)
p1<-ggplot(BOD1, aes(x=occurthan, y=num, group=1)) + geom_line(linetype="solid", color ="#4a9ff5") +geom_point(size=0.6, color ="#4a9ff5" )
p2<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 13),axis.title.x = element_text(size = 13),axis.line = element_line(colour = "black")) 
p2<-p2+xlab("Mutation occurance cutoff") + ylab("Mutation number")
p2
dev.off()


#acdbdf