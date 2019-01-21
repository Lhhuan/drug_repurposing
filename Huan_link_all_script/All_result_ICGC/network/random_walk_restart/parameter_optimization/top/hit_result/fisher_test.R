library(readxl)
library(dplyr)
library(stringr)
library(igraph)


setwd("~/All_result_ICGC/network/random_walk_restart/parameter_optimization/top/hit_result")
org<-read.table("02_drug_hit_repo_and_gene-count_prepare_fisher.txt",header = T)
#org<-read.table("1234.txt",header = T)


rs <- data.frame()
n<-nrow(org)#记录行数

for (i in c(1:n)){ #逐行循环
  a <- org[i,]
  A<- a$repo_gene_large_than_cutoff__A
  B<- a$no_repo_gene_large_than_cutoff__B
  C<-a$C

  D <-12277-A-B-C
  data<-c(A,C,B,D)
  data2<-matrix(data,nrow=2)
  fisher.test(data2)  #fisher 检验
  test_result <-fisher.test(data2)  #%>%as.data.frame()
  p1 <-test_result$p.value
  cutoff <- as.character(a$cutoff)
  ps<-a%>%dplyr::select(drug,repo)
  temp <- data.frame(cutoff,ps,p_value=p1)
  rs <- bind_rows(temp,rs) ##把数据集temp作为新的行添加到rs中
 }
write.table(rs,"fisher_test_result.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来

