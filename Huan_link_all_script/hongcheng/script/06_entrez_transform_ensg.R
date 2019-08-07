library(tidyverse)
library(stringr)
library(mygene)
library(dplyr)
library(readr)

setwd("/f/mulinlab/huan/hongcheng/output")
org<-read_tsv("05_three_source_gene.txt",col_names = T )%>%as.data.frame()

entrez<-org$Entrez%>%unique()
df.0 <- queryMany(entrez, scopes="entrezgene", fields=c("ensembl.gene"), species="human")%>%data.frame()
id.1 <- df.0 %>% dplyr::select(entrezgene = query,ensembl.gene=ensembl)%>% mutate(ensembl.gene=sapply(ensembl.gene, paste0, collapse=","))

di<-"/f/mulinlab/huan/hongcheng/output"
write.table(id.1,file.path(di,"06_entrez_transform_ensg.txt"),quote = F,sep = "\t",row.names = F)
