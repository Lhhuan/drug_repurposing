library(tidyverse)
library(stringr)
library(mygene)

di <- "/f/mulinlab/huan/All_result_ICGC/"

tfs <- read_tsv(file.path(di, "three_source_gene_role.txt"))
en <- tfs$Gene_symbol%>%unique()#%>%data.frame()

#df.0 <- queryMany(en, scopes="symbol", fields=c("ensembl.gene"), species="human")
#df.1 <- as_tibble(df.0) #%>% group_by(query) %>% top_n(1,X_score)
#write_tsv(df.1, file.path(di, "three_source_gene_role_ensg.txt"))
#df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)


df.0 <- queryMany(en, scopes="symbol", fields=c("ensembl.gene","entrezgene","symbol","alias"), species="human")
df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) #查找成功的
df.tmp <- as_tibble(df.0) %>% filter(!is.na(notfound))#查找不成功的




df.0 <- queryMany(df.tmp$query, scopes="alias", fields=c("ensembl.gene","entrezgene","symbol","alias"), species="human") #查找不成功的用别名重新查找。
df.2 <- as_tibble(df.0) %>% group_by(query) %>% top_n(1,X_score)
df.err <- as_tibble(df.0) %>% filter(!is.na(notfound))


id.1 <- df.1 %>% dplyr::select(query,ensembl, entrezgene, symbol) %>% mutate(ensembl=sapply(ensembl, paste0, collapse=","))
#选择需要的列并重命名,并把ensembl.gene转成dataframe
id.2 <- df.2 %>% dplyr::select(query,ensembl, entrezgene, symbol)%>% mutate(ensembl=sapply(ensembl, paste0, collapse=","))
id.e <- df.err %>% dplyr::select(query,ensembl, entrezgene, symbol)%>% mutate(ensembl=sapply(ensembl, paste0, collapse=","))
id <- bind_rows(id.1,id.2,id.e)


write.table(id,file.path(di, "three_source_gene_role_ensg.txt"),quote = F,sep = "\t",row.names = F)
