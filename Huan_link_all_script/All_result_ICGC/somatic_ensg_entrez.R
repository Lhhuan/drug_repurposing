library(tidyverse)
library(stringr)
library(mygene)


setwd("~/All_result")
tfs1 <- read_tsv("somatic_uni_ENSG_ID.txt",col_names = F)
en <- tfs1%>%unique()#%>%data.frame()

df.0 <- queryMany(en, scopes="ensembl.gene", fields=c("entrezgene"), species="human")
df.1 <- as_tibble(df.0) #%>% group_by(query) %>% top_n(1,X_score)
setwd("~/All_result")
write_tsv("somatic_ensg_entrez.txt")
#write_tsv(df.1, file.path(di, "somatic_ensg_entrez.txt"))

#df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)