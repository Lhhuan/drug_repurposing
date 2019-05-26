library(tidyverse)
library(stringr)
library(mygene)
setwd("~/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel")
tfs1 <- read_tsv("10_split_add_hgvsg_symbol.txt",col_names = T)
en <- tfs1$Gene%>%unique()
df.0 <- queryMany(en, scopes="symbol", fields=c("entrezgene","ensembl.gene","symbol"), species="human")
df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) #查找成功的
df.tmp <- as_tibble(df.0) %>% filter(!is.na(notfound))#查找不成功的


df.0 <- queryMany(df.tmp$query, scopes="alias", fields=c("entrezgene","ensembl.gene","symbol"), species="human") #查找不成功的用别名重新查找。
df.2 <- as_tibble(df.0) %>% group_by(query) %>% top_n(1,X_score)
#df.err <- as_tibble(df.0) %>% filter(!is.na(notfound))

id.1 <- df.1 %>% dplyr::select(query,ensembl.gene=ensembl, entrezgene,symbol)%>% mutate(ensembl.gene=sapply(ensembl.gene, paste0, collapse=","))
#选择需要的列并重命名,并把ensembl.gene转成dataframe
id.2 <- df.2 %>% dplyr::select(query,ensembl.gene, entrezgene,symbol)
#id.e <- df.err %>% dplyr::select(query,ensembl.gene, entrezgene)
id <- bind_rows(id.1,id.2)

di<-"~/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel"

write.table(id,file.path(di,"11_transform_add_ensg_entrezid.txt"),quote = F,sep = "\t",row.names = F)
