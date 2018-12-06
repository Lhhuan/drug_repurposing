library(readxl)
library(dplyr)
library(stringr)
library(igraph)


setwd("/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/tmp_shortest_path_data/")
org<-read.table("/f/mulinlab/huan/All_result_ICGC/network/network_gene_num.txt",header = T)
spe<-data.frame(org$id)#把所有的顶点数读进来。
input<-read.table("/f/mulinlab/huan/All_result_ICGC/network/the_shortest_path/normal_network_num.txt",header = T)  #把文件读进来并转为data.frame
df <- data.frame(from=c(input$start), to=c(input$end), weight=c(input$weight))#把读进来的文件转化成图的start,end,weight
g <- graph.data.frame(df,directed=TRUE,vertices=spe) #把读进来的文件转化成图

pairs <-read.table("./08_uni_start_end_shortest10.txt",header = F)%>%as.data.frame()#把要看最短路径start和end的列表读进来。
rs <- data.frame()#构造一个表
N<-nrow(pairs)#看pairs有多少行
for(i in 1:N ){#对每一行进行循环
  start = pairs[i,1] #提第i行的第一列
  end =pairs[i,2]#提第i行的第二列
  sv <- get.shortest.paths(g,start,end,weights=NULL,output="both") #取最短路径 #即返回节点也返回边
  x <- paste(sv$vpath[[1]], collapse="-")#取节点，并指定节点的分隔符
  tmp <- data.frame(start=start,end=end, shortest=x)
  rs <- bind_rows(rs,tmp)
  #print(start)
  #print(end)
  #print(sv)
}
write.table(rs,"09_the_shortest_path10.txt",row.names = F, col.names = T,quote =F,sep="\t")#把表存下来

#sv <- get.shortest.paths(g,2342,10735,weights=NULL,output="both")  #即返回节点也返回边。

#sv <- get.shortest.paths(g,10002,1351,weights=NULL,output="vpath")  #即返回节点不返回边。
#sv <- get.shortest.paths(g,10002,11585,weights=NULL,output="both")  #即返回节点也返回边。

