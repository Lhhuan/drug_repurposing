library(ggplot2)
library(dplyr)
library(Rcpp)
library(readxl)
library(stringr)
library(gcookbook)

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

#--------------------------------------------------
#----------------------------构造一个数组
occurs_array<-seq(2,10,by=1)
#-----------------------------------处理translocation
#--------------------------------------------------
n_translocation<-nrow(translocation)
translocation_num_sta<-data.frame() #新建一个表

#---------------------------------------添加标签
#translocation1 <-translocation %>% dplyr::select(mutation_number,occur_time)%>% group_by(mutation_number)
for(i in occurs_array){
  occurs <- filter(translocation, abs(occur_time - i)<0.0000001 )%>%as.data.frame()
  number<-nrow(occurs)
  temp <- data.frame(occur_time=i,occur_number=number)
  translocation_num_sta<-bind_rows(temp,translocation_num_sta)
}

occurs <- filter(translocation, occur_time>10 )%>%as.data.frame()
temp <- data.frame(occur_time= 11,occur_number = nrow(occurs)) #把大于10的归为一类,并记录为11
translocation_num_sta<-rbind(translocation_num_sta,temp)
#---------------------------------------添加标签
translocation_num_sta<-mutate(translocation_num_sta,mutation_number_ratio = occur_number/n_translocation*100) #除以总突变数
translocation_num_sta$class <-c("translocation")


#-----------------------------------处理inversion
#--------------------------------------------------
n_inversion<-nrow(inversion)
inversion_num_sta<-data.frame() #新建一个表

for(i in occurs_array){
  occurs <- filter(inversion, abs(occur_time - i)<0.0000001 )%>%as.data.frame()
  number<-nrow(occurs)
  temp <- data.frame(occur_time=i,occur_number=number)
  inversion_num_sta<-bind_rows(temp,inversion_num_sta)
}

occurs <- filter(inversion, occur_time>10 )%>%as.data.frame()
temp <- data.frame(occur_time= 11,occur_number = nrow(occurs)) #把大于10的归为一类,并记录为11
inversion_num_sta<-rbind(inversion_num_sta,temp)
#---------------------------------------增加百分比，添加标签
inversion_num_sta<-mutate(inversion_num_sta,mutation_number_ratio = occur_number/n_inversion*100) #除以总突变数
inversion_num_sta$class <-c("inversion")

#-----------------------------------处理cnv
#--------------------------------------------------
n_cnv<-nrow(cnv)
cnv_num_sta<-data.frame() #新建一个表

for(i in occurs_array){
  occurs <- filter(cnv, abs(occur_time - i)<0.0000001 )%>%as.data.frame()
  number<-nrow(occurs)
  temp <- data.frame(occur_time=i,occur_number=number)
  cnv_num_sta<-bind_rows(temp,cnv_num_sta)
}

occurs <- filter(cnv, occur_time>10 )%>%as.data.frame()
temp <- data.frame(occur_time= 11,occur_number = nrow(occurs)) #把大于10的归为一类,并记录为11
cnv_num_sta<-rbind(cnv_num_sta,temp)
#---------------------------------------增加百分比，添加标签
cnv_num_sta<-mutate(cnv_num_sta,mutation_number_ratio = occur_number/n_cnv*100) #除以总突变数
cnv_num_sta$class <-c("cnv")
#---------------------------------------------------------
#-----------------------------------处理deletion
#--------------------------------------------------
n_deletion<-nrow(deletion)
deletion_num_sta<-data.frame() #新建一个表

for(i in occurs_array){
  occurs <- filter(deletion, abs(occur_time - i)<0.0000001 )%>%as.data.frame()
  number<-nrow(occurs)
  temp <- data.frame(occur_time=i,occur_number=number)
  deletion_num_sta<-bind_rows(temp,deletion_num_sta)
}

occurs <- filter(deletion, occur_time>10 )%>%as.data.frame()
temp <- data.frame(occur_time= 11,occur_number = nrow(occurs)) #把大于10的归为一类,并记录为11
deletion_num_sta<-rbind(deletion_num_sta,temp)
#---------------------------------------增加百分比，添加标签
deletion_num_sta<-mutate(deletion_num_sta,mutation_number_ratio = occur_number/n_deletion*100) #除以总突变数
deletion_num_sta$class <-c("deletion")
#---------------------------------------------------------
#-----------------------------------处理duplication
#--------------------------------------------------
n_duplication<-nrow(duplication)
duplication_num_sta<-data.frame() #新建一个表

for(i in occurs_array){
  occurs <- filter(duplication, abs(occur_time - i)<0.0000001 )%>%as.data.frame()
  number<-nrow(occurs)
  temp <- data.frame(occur_time=i,occur_number=number)
  duplication_num_sta<-bind_rows(temp,duplication_num_sta)
}

occurs <- filter(duplication, occur_time>10 )%>%as.data.frame()
temp <- data.frame(occur_time= 11,occur_number = nrow(occurs)) #把大于10的归为一类,并记录为11
duplication_num_sta<-rbind(duplication_num_sta,temp)
#---------------------------------------增加百分比，添加标签
duplication_num_sta<-mutate(duplication_num_sta,mutation_number_ratio = occur_number/n_duplication*100) #除以总突变数
duplication_num_sta$class <-c("duplication") #添加标签
#---------------------------------------------------------
#-----------------------------------处理snv
#--------------------------------------------------
n_snv<-nrow(snv)
snv_num_sta<-data.frame() #新建一个表

for(i in occurs_array){
  occurs <- filter(snv, abs(occur_time - i)<0.0000001 )%>%as.data.frame()
  number<-nrow(occurs)
  temp <- data.frame(occur_time=i,occur_number=number)
  snv_num_sta<-bind_rows(temp,snv_num_sta)
}

occurs <- filter(snv, occur_time>10 )%>%as.data.frame()
#temp <- data.frame(occur_time= ">10",occur_number = nrow(occurs)) #把大于10的归为一类
temp <- data.frame(occur_time= 11,occur_number = nrow(occurs)) #把大于10的归为一类,并记录为11
snv_num_sta<-rbind(snv_num_sta,temp)
#---------------------------------------增加百分比，添加标签
snv_num_sta<-mutate(snv_num_sta,mutation_number_ratio = occur_number/n_snv*100) #除以总突变数
snv_num_sta$class <-c("snv") #添加标签
#---------------------------------------------------------
#--------------------------------
org<- bind_rows(translocation_num_sta,inversion_num_sta,cnv_num_sta,deletion_num_sta,duplication_num_sta,snv_num_sta)

p<-ggplot(org,aes(x = occur_time, y = mutation_number_ratio, fill = class)) + geom_bar(stat = 'identity', position = 'dodge')
p+scale_x_continuous(breaks=c(2,3,4,5,6,7,8,9,10))
p+ scale_x_discrete(limits=c(4,3))


