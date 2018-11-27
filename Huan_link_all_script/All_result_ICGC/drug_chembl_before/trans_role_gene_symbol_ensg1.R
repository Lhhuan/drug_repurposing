library(tidyverse)
library(stringr)
library(mygene)

di <- "/f/mulinlab/huan/All_result/"

tfs <- read_tsv(file.path(di, "three_source_gene_role.txt"))
en <- tfs$Gene_symbol%>%unique()#%>%data.frame()

df.0 <- queryMany(en, scopes="symbol", fields=c("ensembl.gene"), species="human")
df.1 <- as_tibble(df.0) #%>% group_by(query) %>% top_n(1,X_score)
write_tsv(df.1, file.path(di, "three_source_gene_role_ensg.txt"))
#df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)