library(gcookbook)
library(dplyr)
library(ggplot2)
setwd("/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/data_statistics/")
f<-read_tsv("network_cancer_drug_repo_count.txt",col_names = T)#%>%as.data.frame()
ggplot(f,aes(y=cancer,x=drug_num)) + geom_point()+
  scale_fill_brewer(palette = "Pastel1")+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15),axis.line = element_line(colour = "black"))
