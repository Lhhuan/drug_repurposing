library(MASS)
library(dplyr)
library(tidyverse)
library(ggplot2)

setwd("/f/mulinlab/huan/Figure_V2/script/")
dit <-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/pathogenicity_mutation_cancer/output/"
org<-read_tsv(file.path(dit, "count_number_of_Pathogenic_mutation_map_to_per_level.txt")) %>%as.data.frame()


#mycolor<-c("#c6cfff","#ffd3de","#e8d3ff","#8ed6ff","#acdbdf")
mycolor<-c("#f9c00c","#00b9f1","#7200da","#f9320c","#75D701")
setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("08_Distribution_of_Pathogenic_mutation_map_to_gene_level_percentage.pdf",height = 3.5,width = 4) #把图片存下来
pie(org$mutation_number, labels = org$percentage, cex=0.85,col = mycolor)
legend("topright", c("Level1.1","Level1.2","Level2","Level3.1","Level3.2"), cex = 0.55, fill = mycolor)
dev.off()

setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("08_Distribution_of_Pathogenic_mutation_map_to_gene_level_number.pdf",height = 3.5,width = 4) #把图片存下来
pie(org$mutation_number, labels = org$mutation_number, cex=0.85,col = mycolor)
legend("topright", c("Level1.1","Level1.2","Level2","Level3.1","Level3.2"), cex = 0.55, fill = mycolor)
dev.off()