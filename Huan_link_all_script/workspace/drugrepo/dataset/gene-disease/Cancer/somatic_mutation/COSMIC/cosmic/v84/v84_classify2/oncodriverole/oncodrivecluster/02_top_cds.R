#选出基因所对应的最长的转录本

library(readxl)
library(dplyr)
library(stringr)
library(RCurl)
library(RISmed)

setwd ("~/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/oncodriverole/oncodrivecluster/")
gene_tran <- read.table("01_gene_transcript.txt",header = T)%>%unique()
gene_tran1 <- gene_tran%>%as.data.frame()%>% group_by(Symbol)%>% top_n(1,CDS_Length)

setwd ("~/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/oncodriverole/oncodrivecluster/")
write.table(gene_tran1,'02_top_gene_transcript.txt',row.names = F, col.names = T, quote = F,sep = "\t")
