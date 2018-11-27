

setwd("~/All_result/network/drug_target_rwr_result")

s<-read.table("single.txt",header = F)%>%as.data.frame()
pa<-read.table("rwr_hit.txt",header = F)%>%as.data.frame()
pf<-dplyr::anti_join(pa,s,by="V1")
same <-dplyr::inner_join(pa,s,by="V1")
sf<-dplyr::anti_join(s,pa,by="V1")
