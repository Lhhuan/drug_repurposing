library(tidyverse)
library(stringr)
library(mygene)

di <- "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING"
#di <- "01_tfs"
# GTRD
tfs <- read_tsv(file.path(di, "06_uni_target.txt"))

df.0 <- queryMany(tfs, scopes="symbol", fields=c("ensembl.gene","entrezgene","symbol","alias"), species="human")
df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) #查找成功的
df.tmp <- as_tibble(df.0) %>% filter(!is.na(notfound))#查找不成功的




df.0 <- queryMany(df.tmp$query, scopes="alias", fields=c("ensembl.gene","entrezgene","symbol","alias"), species="human") #查找不成功的用别名重新查找。
df.2 <- as_tibble(df.0) %>% group_by(query) %>% top_n(1,X_score)
df.err <- as_tibble(df.0) %>% filter(!is.na(notfound))


id.1 <- df.1 %>% dplyr::select(query,ensembl.gene=ensembl, entrezgene, symbol) %>% mutate(ensembl.gene=sapply(ensembl.gene, paste0, collapse=","))
#选择需要的列并重命名,并把ensembl.gene转成dataframe
id.2 <- df.2 %>% dplyr::select(query,ensembl.gene, entrezgene, symbol)
id.e <- df.err %>% dplyr::select(query,ensembl.gene, entrezgene, symbol)
id <- bind_rows(id.1,id.2)


write.table(id,file.path(di,"transform.txt"),quote = F,sep = "\t",row.names = F)
