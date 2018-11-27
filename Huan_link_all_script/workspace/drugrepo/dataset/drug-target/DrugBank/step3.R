library(tidyverse)
library(stringr)
library(mygene)

di <- "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank"
#di <- "01_tfs"
# GTRD
tfs <- read_tsv(file.path(di, "step2_result_gene_drug.txt"))
#tfs <- read_tsv(file.path("/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/getfromdrugbank2017-12-18.txt"))
df.0 <- queryMany(tfs$ENSGID, scopes="ensembl.gene", fields=c("entrezgene"), species="human")
df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)
write_tsv(df.1, file.path(di, "transform.txt"))
#?read_tsv
