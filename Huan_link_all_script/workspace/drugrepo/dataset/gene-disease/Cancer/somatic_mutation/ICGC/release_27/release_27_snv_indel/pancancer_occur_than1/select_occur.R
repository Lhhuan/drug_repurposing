library(gcookbook)
library(ggplot2)

setwd("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/")
BOD1<-read_tsv("occur_num.txt",col_names = T )%>%as.data.frame()
ggplot(BOD1, aes(x=occurthan, y=num, group=1)) + geom_line(linetype="solid") +geom_point(size=1)


BOD1 <- read_tsv
