library(tidyverse)
library(stringr)
library(dplyr)
library(readr)

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/")
org<-read_tsv("./output/drug_target_score_and_bioactivities.txt",col_names = T )%>%as.data.frame()

cor(x = org$drug_target_score, y = org$PACTIVITY_median, use = "everything", method = "pearson")


cor.test(x = org[,"drug_target_score"], y = org[,"PACTIVITY_median"])
