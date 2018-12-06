library(readxl)
library(dplyr)
library(stringr)
library(igraph)


#setwd("~/All_result/network/random_walk_restart/parameter_optimization/top/hit_result")
setwd("/media/mulinlab/Data02/huan/All_result/network/random_walk_restart/parameter_optimization/top/hit_result")
#org<-read.table("02_drug_hit_repo_and_gene-count_prepare_fisher.txt",header = T)
org<-read.table("test_fisher1234.txt",header = T)

#cutoffs<-seq(0.0001,0.1,by=0.0001)#%>%as.data.frame() #构造cutoff
cutoffs<-seq(0.0001,0.0002,by=0.0001)#%>%as.data.frame()

rs <- data.frame(cutoff =character(),drug = character(),repo= character(),p_value = numeric()) #all result   #构造一个表

for (i in cutoffs ){
  
    #i<-i%>%as.data.frame()
  cutoff_data <- filter(org, abs(cutoff-i)<0.0000001 )%>%as.data.frame() #差取绝对值小于一个特别小的值，处理浮点数
  N <- nrow(cutoff_data) #看cutoff_data 有多少行
  for (s in 1:N) {#对每一行进行循环
    ##------------------------------------------读入表格
    drug_name = cutoff_data[s,2]
    repo_disease= cutoff_data[s,3]
    #------------------------------------------------列出用于Fisher exact test的值
    #----------------------------------------------------------------#计算ABCD的值
    A<-cutoff_data%>%dplyr::select(repo_gene_large_than_cutoff__A)
    A = cutoff_data[s,5]#第s行的第5列
    B<-cutoff_data[s,6]
    C<-cutoff_data[s,8]
    D<-12277-A-B-C
    
    data<-c(A,C,B,D)
    
    print(paste(A, i))
    
    data2<-matrix(data,nrow=2)
    fisher.test(data2)  #fisher 检验
    test_result <-fisher.test(data2)  #%>%as.data.frame()
    i1 <- as.character(i)
    p1 <-test_result$p.value
    temp <- data.frame(cutoff = i1,drug=drug_name,repo= repo_disease, p_value=p1)
    rs <- bind_rows(rs,temp) ##把数据集temp作为新的行添加到rs中
  }
}
write.table(rs,"fisher_test_result.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来
