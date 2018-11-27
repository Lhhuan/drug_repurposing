library(readxl)
library(dplyr)
library(stringr)
library(igraph)


setwd("/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/")
org<-read.table("/f/mulinlab/huan/All_result_ICGC/network/network_gene_num.txt",header = T)
spe<-data.frame(org$id)#把所有的顶点数读进来。
input<-read.table("/f/mulinlab/huan/All_result_ICGC/network/the_shortest_path/normal_network_num.txt",header = T)  #把文件读进来并转为data.frame
df <- data.frame(from=c(input$start), to=c(input$end), weight=c(input$weight))#把读进来的文件转化成图的start,end,weight
g <- graph.data.frame(df,directed=TRUE,vertices=spe) #把读进来的文件转化成图
mean_shortest_length<-mean_distance(g)%>%as.data.frame() #计算网络中平均最短路径。

setwd("/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/")

rs <- data.frame()#构造一个表
rs <- bind_rows(rs,mean_shortest_length)
write.table(rs,"9.1_the_mean_shortest_length.txt",row.names = F, col.names = F,quote =F,sep="\t")#把表存下来
