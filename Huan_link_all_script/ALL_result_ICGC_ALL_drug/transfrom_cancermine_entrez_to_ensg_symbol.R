library(tidyverse)
library(stringr)
library(mygene)
library(dplyr)
library(readr)

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/")
org<-read_tsv("./output/cancermine_collated.tsv",col_names = T )%>%as.data.frame()

entrez<-org$gene_entrez_id%>%unique()
df.0 <- queryMany(entrez, scopes="entrezgene", fields=c("symbol","ensembl.gene"), species="human")%>%data.frame()
id.1 <- df.0 %>% dplyr::select(entrezgene = query,ensembl.gene=ensembl,symbol)%>% mutate(ensembl.gene=sapply(ensembl.gene, paste0, collapse=","))

di<-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output"
write.table(id.1,file.path(di,"transfrom_cancermine_entrez_to_ensg_symbol.txt"),quote = F,sep = "\t",row.names = F)

