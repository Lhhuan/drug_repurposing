library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)
library(readr)
setwd("/f/mulinlab/huan/Figure_V2/script/")
dit <-"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/pathogenicity_mutation_cancer/output/"

org<-read_tsv(file.path(dit, "sv_snv_number.txt"))
# org$Source = factor(org$Source, levels=c("SNV/Indel","CNV", "Deletion","Duplication","Inversion","Translocation"))


mycolor<-c("#f9c00c","#00b9f1","#7200da","#f9320c","#75D701","#00a03e")
setwd("/f/mulinlab/huan/Figure_V2/figures/")
# pdf("06_snv_sv_number_count.pdf",height = 3.5,width = 4) #把图片存下来
pie(org$number, labels = org$number, cex=0.75,col = mycolor)
#legend("topright", cex = 0.55, fill = mycolor)
legend("topright",  c("SNV/Indel","CNV", "Deletion","Duplication","Inversion","Translocation"), cex = 0.55, fill = mycolor)
#dev.off()
