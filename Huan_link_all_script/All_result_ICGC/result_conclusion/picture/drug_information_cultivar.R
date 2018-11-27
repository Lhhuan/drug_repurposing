library(gcookbook)
library(dplyr)
library(ggplot2)
setwd("~/All_result/result_conclusion/picture")
f<-read_tsv("indication.txt",col_names = T)#%>%as.data.frame()

ggplot(f, mapping = aes(x = Ontology, y = num, fill = type)) + geom_bar(stat = 'identity', position = 'stack', width = 0.4) + 
  scale_fill_brewer(palette = "Pastel1")+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), legend.text=element_text(size = 15),legend.title=element_text(size = 15),axis.text.y = element_text(size = 15),axis.title.y = element_text(size = 15),axis.text.x = element_text(size = 15),axis.title.x = element_text(size = 15),axis.line = element_line(colour = "black"))


f1<-read_tsv("gene_info.txt",col_names = T)#%>%as.data.frame()
ggplot(f1, mapping = aes(x = Gene_type, y = num, fill = num_name)) + geom_bar(stat = 'identity', position = 'dodge', width = 0.9) +
  scale_fill_brewer(palette = "Pastel1")+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), legend.text=element_text(size = 15),legend.title=element_text(size = 15),axis.text.y = element_text(size = 15),axis.title.y = element_text(size = 15),axis.text.x = element_text(size = 15),axis.title.x = element_text(size = 15),axis.line = element_line(colour = "black"))

f2<-read_tsv("drug_indication.txt",col_names = T)#%>%as.data.frame()
ggplot(f2, mapping = aes(x =name, y = num))+geom_bar(stat="identity",width = 0.4,fill="grey")+theme(panel.grid.major = element_blank(),axis.text.y = element_text(size = 15),axis.title.y = element_text(size = 15),axis.text.x = element_text(size = 15),axis.title.x = element_text(size = 15),panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"))
