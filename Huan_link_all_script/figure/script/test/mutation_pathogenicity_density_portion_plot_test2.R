library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)

setwd("/f/mulinlab/huan/figure/script/")

dit <- "~/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_Pathogenicity/output"
files <- list.files(dit,"txt")#获取dit下的所有文件

number_sta<-data.frame()
for (fi in files){ #对files的文件循环操作
  name <- str_replace(fi,"Pathogenicity_score_","") %>%str_replace(".txt","") #首先把Pathogenicity_score_替换成空，然后把.txt替换成空,有了unique的名字,方便后面加lable
  print(fi)
  t <- read.table(file.path(dit,fi),header =T,sep = "\t")%>% dplyr::rename("Pathogenicity_score"="SVSCORETOP10")
  n_name<-nrow(t)
  #name_num_sta<-data.frame() #新建一个表
  path_arrays<-c(0,15,16,17,18,19,20)
  l_a<-length(path_arrays)
  for (i in c(1:l_a)){
    if(i<l_a){
    pats <- filter(t, Pathogenicity_score>=path_arrays[i] & Pathogenicity_score<path_arrays[i+1] )%>%as.data.frame() #根据筛选Pathogenicity_score筛选表
    number<-nrow(pats)
    
    temp <- data.frame(Pathogenicity_score=path_arrays[i]-path_arrays[i+1],path_number=number)
    }
  }
  

  fo <- paste0(name,"_processed.txt")
 
  # dio <- ""
  # write.table(dd,file.path(dio,fo),sep = )
}
