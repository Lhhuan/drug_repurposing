library(tidyverse)
library(stringr)
library(GenomicFeatures)
library(mygene)
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/")
di<-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/"


tfs <- read_tsv('./output/network_gene_num.txt', col_names=F)
df.0 <- queryMany(tfs$X1, scopes="symbol", fields=c("symbol"), species="human")
df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)
df.tmp <- as_tibble(df.0) %>% filter(!is.na(notfound))#查找不成功的


df.00 <- queryMany(df.tmp$query, scopes="alias", fields=c("symbol"), species="human") #查找不成功的用别名重新查找。
df.2 <- as_tibble(df.00) %>%filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score) #注意这里面有分数相同的，在perl里读的时候只读第一个
df.err <- as_tibble(df.00) %>% filter(!is.na(notfound))


id.1 <- df.1 %>% dplyr::select(query,symbol)
id.2 <- df.2 %>% dplyr::select(query,symbol)
id.e <- df.err %>% dplyr::select(query,symbol)
id <- bind_rows(id.1,id.2,id.e) %>%unique()

write.table(id,file.path(di,"network_alias_to_symbol.txt"),quote = F,sep = "\t",row.names = F)

