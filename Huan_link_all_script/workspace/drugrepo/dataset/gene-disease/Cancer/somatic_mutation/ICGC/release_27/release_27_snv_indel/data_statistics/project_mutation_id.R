library(MASS)
library(dplyr)
library(ggplot2)

setwd("~/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics")
f<-read_tsv("final_oncotree-id_mutation_num_m.txt",col_names = T)%>%as.data.frame()
cl <- colors()
head(cl,200)
mycolors <- colorRampPalette(c("dodgerblue3","deepskyblue3","cadetblue2","cadetblue1"))(33)#自动调色
barplot(rep(1,times=28),col=mycolors,border=mycolors,axes=FALSE); box()

pie(f$involve_mutationID_num,labels = f$oncotree_id_label,main="per cancer mutation",col = mycolors,col.main="black", cex.main=2,cex=0.7)



f<-read_tsv("man_sorted_final_project_no_country_id_num_label.txt",col_names = T)%>%as.data.frame()



#pie(f$involve_mutationID_num,labels = f$project,main="per cancer mutation",col = rainbow(33),col.main="blue", cex.main=2,cex=0.8)
#pie(f$involve_mutationID_num,labels = f$project,main="per cancer mutation",col = grey(seq(0.4, 1.0, length = 33)),col.main="blue", cex.main=2,cex=0.8)

#pie(y, col =gray(seq(0.4, 1.0, length = 33)))

#cl <- colors()
#head(cl,200)


#mycolors <- colorRampPalette(c("blue4","blanchedalmond", "aliceblue","coral","cadetblue"))(33)  #自动调色
#barplot(rep(1,times=33),col=mycolors,border=mycolors,axes=FALSE); box()


#mycolors <- colorRampPalette(c("dodgerblue3","deepskyblue3","cadetblue2"))(33)
#barplot(rep(1,times=33),col=mycolors,border=mycolors,axes=FALSE); box()


#mycolors <- colorRampPalette(c("dodgerblue3"))(33)
#barplot(rep(1,times=33),col=mycolors,border=mycolors,axes=FALSE); box()
