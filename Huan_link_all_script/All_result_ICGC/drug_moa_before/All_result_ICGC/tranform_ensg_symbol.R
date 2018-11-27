library(tidyverse)
library(stringr)
library(mygene)

di <- "/f/mulinlab/huan/All_result_ICGC/"

tfs <- read_tsv(file.path(di, "huan_target_drug_indication_no_symbol.txt"))
en <- tfs$ENSG_ID%>%unique()#%>%data.frame()

df.0 <- queryMany(en, scopes="ensembl.gene", fields=c("symbol"), species="human")
df.1 <- as_tibble(df.0) #%>% group_by(query) %>% top_n(1,X_score)
write_tsv(df.1, file.path(di, "huan_transform_ensg_symbol.txt"))
#df.1 <- as_tibble(df.0) %>% filter(is.na(notfound)) %>% group_by(query) %>% top_n(1,X_score)