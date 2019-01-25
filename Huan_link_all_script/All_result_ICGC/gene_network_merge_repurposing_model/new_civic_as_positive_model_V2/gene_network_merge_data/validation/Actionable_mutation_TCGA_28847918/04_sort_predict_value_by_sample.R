library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)

setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/Actionable_mutation_TCGA_28847918/")
org<-read.table("./output/03_prediction_logistic_regression.txt",header = T,sep = "\t") %>% as.data.frame()
sort_org <- org%>%group_by(paper_sample_name)%>%arrange(desc(predict_value))%>%top_n(1)

write.table(sort_org,"./output/04_sample_in_paper_top_repurposing_value.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来


# ss <-sort_org$paper_sample_name %>%as.data.frame()%>% unique()
# colnames(ss) <- c("paper_sample_name")
# anti <- anti_join(ss,sort_org,by= "paper_sample_name")