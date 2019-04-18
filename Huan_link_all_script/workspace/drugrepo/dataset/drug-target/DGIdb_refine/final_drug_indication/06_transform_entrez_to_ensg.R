library(tidyverse)
library(stringr)
library(mygene)
library(readr)

di <- "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/final_drug_indication/output/"
#di <- "01_tfs"
# GTRD
tfs <-  read.table(file.path(di, "uni_Entrez_id.txt"),header = F) %>% dplyr::rename("Entrez_id" = "V1")
df.0 <- queryMany(tfs$Entrez_id, scopes="entrezgene", fields=c("ensembl.gene"), species="human")
df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)
write_tsv(df.1, file.path(di, "transform.txt"))
#write.table(df.1, "transform.txt",col.names = T,  quote = F,sep = "\t")

# #df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(2,X_score)
# #write_tsv(df.1, file.path(di, "transform1.txt"))
# df.err <- as_tibble(df.0) %>% filter(!is.na(notfound))
# id.1 <- df.1 %>% dplyr::select(query, symbol, alias)
# id <- id.1 %>% mutate(alias=sapply(alias, paste0, collapse=","))
# tf.final <- inner_join(tfs, id, by=c("tf1"="query")) %>% dplyr::select(tf0, tf1, symbol) %>% unique()
# write_tsv(tf.final, file.path(di, "GTRD_tfs_final.txt"))
# id.e <- df.err %>% dplyr::select(query, symbol, alias)
# id.e <- inner_join(tfs, id.e, by=c("tf1"="query")) %>% dplyr::select(tf0, tf1, symbol) %>% unique()
# write_tsv(id.e, file.path(di, "GTRD_tfs_final.err"))

# # ReMap2
# tfs <- read_tsv(file.path(di, "ReMap2_tfs_clean.txt"))
# df.0 <- queryMany(tfs$tf1, scopes=c("symbol","alias"), fields=c("symbol","alias"), species="human")
# df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)
# df.err <- as_tibble(df.0) %>% filter(!is.na(notfound))
# id.1 <- df.1 %>% dplyr::select(query, symbol, alias)
# id <- id.1 %>% mutate(alias=sapply(alias, paste0, collapse=","))
# tf.final <- inner_join(tfs, id, by=c("tf1"="query")) %>% dplyr::select(tf0, tf1, symbol) %>% unique()
# write_tsv(tf.final, file.path(di, "ReMap2_tfs_final.txt"))
# id.e <- df.err %>% dplyr::select(query, symbol, alias)
# id.e <- inner_join(tfs, id.e, by=c("tf1"="query")) %>% dplyr::select(tf0, tf1, symbol) %>% unique()
# write_tsv(id.e, file.path(di, "ReMap2_tfs_final.err"))
