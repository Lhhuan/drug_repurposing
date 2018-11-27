library(gcookbook)
library(dplyr)
library(ggplot2)
setwd("/f/mulinlab/huan/All_result_ICGC/result_conclusion/picture/")
f<-read_tsv("logic_true_repo_drug_count.txt",col_names = T)#%>%as.data.frame()
ggplot(f,aes(y=cancer,x=drug_num)) + geom_point()+
  scale_fill_brewer(palette = "Pastel1")+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15),axis.line = element_line(colour = "black"))
