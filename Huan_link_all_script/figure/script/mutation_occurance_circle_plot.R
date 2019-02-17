# Charge the circlize library
library(circlize)
library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)

setwd("/f/mulinlab/huan/figure/script/")
translocation<-read.table("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_occur_time/output/occur_time_translocation.txt"
                 ,header = T,sep = "\t") %>% as.data.frame()
inversion<-read.table("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_occur_time/output/occur_time_inversion.txt"
                          ,header = T,sep = "\t") %>% as.data.frame()
cnv<-read.table("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_occur_time/output/occur_time_cnv.txt"
                      ,header = T,sep = "\t") %>% as.data.frame()
deletion<-read.table("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_occur_time/output/occur_time_deletion.txt"
                ,header = T,sep = "\t") %>% as.data.frame()
duplication<-read.table("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_occur_time/output/occur_time_duplication.txt"
                     ,header = T,sep = "\t") %>% as.data.frame()
snv <-read.table("/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/pancancer_mutation.largethan1_occurance.txt"
                 ,header = T,sep = "\t") %>% as.data.frame()
#-----------------------------把行名作为第一列
mutation_number <- rownames(translocation)
rownames(translocation) <- NULL
translocation <- cbind(mutation_number,translocation)
#-------------------------------------
mutation_number <-rownames(inversion)
rownames(inversion) <- NULL
inversion <- cbind(mutation_number,inversion)
#------------------------------------------
mutation_number <-rownames(cnv)
rownames(cnv) <- NULL
cnv <- cbind(mutation_number,cnv)
#---------------------------------------------
mutation_number <-rownames(deletion)
rownames(deletion) <- NULL
deletion <- cbind(mutation_number,deletion)
#--------------------------------------------
mutation_number <-rownames(duplication)
rownames(duplication) <- NULL
duplication <- cbind(mutation_number,duplication)
#-----------------------------------------------------
mutation_number <-rownames(snv)
rownames(snv) <- NULL
snv <- cbind(mutation_number,snv)

#---------------------------------------添加标签
translocation1 <-translocation %>% dplyr::select(mutation_number,occur_time)
translocation1$class <-c("translocation")

inversion1<-inversion %>% dplyr::select(mutation_number,occur_time)
inversion1$class <-c("inversion")

cnv1<-cnv %>% dplyr::select(mutation_number,occur_time)
cnv1$class <-c("cnv")

deletion1<-deletion %>% dplyr::select(mutation_number,occur_time)
deletion1$class <-c("deletion")

duplication1<-duplication %>% dplyr::select(mutation_number,occur_time)
duplication1$class <-c("duplication")

snv1<-snv %>% dplyr::select(mutation_number,occur_time)
snv1$class <-c("snv")

#--------------------------------
org<- bind_rows(translocation1,inversion1,cnv1,deletion1,duplication1,snv1)
org$class <- as.factor(org$class)

# General parameters
circos.par("track.height" = 0.4)
#Initialize chart
circos.par(cell.padding =
             c(0.02, 0, 0.02, 0))
circos.initialize(factors = org$class, x = org$mutation_number)

# Build the regions. 
circos.trackPlotRegion(factors = org$class, y=org$occur_time, panel.fun = function(x, y) {
  circos.axis(labels.cex=0.1, labels.font=1, lwd=0.8, h="bottom", direction="inside")
})
