library(tidyverse)
library(stringr)
library(GenomicFeatures)
library(mygene)
di<-"~/All_result_ICGC"


tfs <- read_tsv('normal_DGIDB_drug_target_score.txt', col_names=T)
gene1 <-tfs$gene%>%unique()
df.0 <- queryMany(gene1, scopes="symbol", fields=c("entrezgene","ensembl.gene"), species="human")
df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)
df.tmp <- as_tibble(df.0) %>% filter(!is.na(notfound))#查找不成功的


df.00 <- queryMany(df.tmp$query, scopes="alias", fields=c("entrezgene","ensembl.gene"), species="human") #查找不成功的用别名重新查找。
df.2 <- as_tibble(df.00) %>%filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score) #注意这里面有分数相同的，在perl里读的时候只读第一个
df.err <- as_tibble(df.00) %>% filter(!is.na(notfound))


id.1 <- df.1 %>% dplyr::select(query,entrezgene,ensembl.gene=ensembl)%>% mutate(ensembl.gene=sapply(ensembl.gene, paste0, collapse=","))
id.2 <- df.2 %>% dplyr::select(query,entrezgene,ensembl.gene)%>% mutate(ensembl.gene=sapply(ensembl.gene, paste0, collapse=","))
#id.e <- df.err %>% dplyr::select(query,entrezgene)
id <- bind_rows(id.1,id.2) 

write.table(id,file.path(di,"tranfrom_dgidb_target_score_symbol_ensgid_entrezid.txt"),quote = F,sep = "\t",row.names = F)
