library(tidyverse)
library(stringr)
#library(GenomicFeatures)
library(mygene)

setwd("~/All_result/network/rwr_parameter_optimization/repodb_disgenet")
#di <- "01_tfs"
# GTRD
tfs <- read_tsv('02_uni_end.txt', col_names=F)
df.0 <- queryMany(tfs$X1, scopes="symbol", fields=c("entrezgene"), species="human")
#df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)
df.1 <- as_tibble(df.0) %>% group_by(query) %>% top_n(1,X_score)
write_tsv(df.1, file.path("02_unique_end_symbol_to_entrez.txt"))
