library(tidyverse)
library(stringr)
#library(GenomicFeatures)
library(mygene)

setwd("~/All_result/network/rwr_parameter_optimization")
#di <- "01_tfs"
# GTRD
tfs <- read_tsv('test_gene_list.txt', col_names=F)
df.0 <- queryMany(tfs$X1, scopes="symbol", fields=c("entrezgene"), species="human")
df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)
write_tsv(df.1, file.path("02_testgene_list_symbol_to_entrez.txt"))
