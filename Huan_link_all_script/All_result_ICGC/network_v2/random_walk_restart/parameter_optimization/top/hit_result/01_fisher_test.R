library(readxl)
library(dplyr)
library(stringr)
library(igraph)


setwd("~/All_result/network/random_walk_restart/parameter_optimization/top/hit_result")
org<-read.table("drug_hit_all_repo_gene_count_result.txt",header = T)
#org<-read.table("1234.txt",header = T)

cutoffs<-seq(0.0001,0.1,by=0.0001)#%>%as.data.frame() #构造cutoff
#cutoffs<-seq(0.05,0.1,by=0.01)#%>%as.data.frame()

rs <- data.frame(cutoff =character(),p_value = numeric()) #all result   #构造一个表

for (i in cutoffs ){
  
  #i<-i%>%as.data.frame()
  cutoff_data <- filter(org, abs(cutoff-i)<0.0000001 )%>%as.data.frame()
  #cutoff_data <-subset(org,cutoff==i)
  hit_gene <- cutoff_data%>%dplyr::select(hit_gene_count)
  
  #----------------------------------------------------------------#计算ABCD的值
  sum_of_hit_gene <- sum(as.numeric(hit_gene$hit_gene_count))
  A<- sum_of_hit_gene
  not_hit <- cutoff_data%>%dplyr::select(not_hit_gene)
  all_no_hit_gene <- sum(not_hit)
  C <- all_no_hit_gene
  all_drugs<-cutoff_data%>%dplyr::select(drug) %>%unique()%>%as.data.frame()
  s<- nrow(all_drugs)
  b <- i*12277*s
  b1<- round(b,0)
  B<- b1-A
  D <-s*12277-A-B-C
  data<-c(A,C,B,D)
  
  
  #print(paste(3, i))
  
  data2<-matrix(data,nrow=2)
  fisher.test(data2)  #fisher 检验
  test_result <-fisher.test(data2)  #%>%as.data.frame()
  i1 <- as.character(i)
  p1 <-test_result$p.value
  temp <- data.frame(cutoff = i1,p_value=p1)
  rs <- bind_rows(rs,temp) ##把数据集temp作为新的行添加到rs中
  #write.table(rs,"fisher_test_result.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
}
write.table(rs,"fisher_test_result.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来

