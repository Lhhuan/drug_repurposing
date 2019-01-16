library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)
library(ggpubr)

setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/")
org1<-read.table("./output/15_pandrug_top_0_0.1_final.txt",header = T,sep = "\t") %>% as.data.frame()#%>%dplyr::select(value_in_paper,proportion)

org2<-read.table("./output/15_pandrug_top_0.1_0.2_final.txt",header = T,sep = "\t")
org3<-read.table("./output/15_pandrug_top_0.2_0.3_final.txt",header = T,sep = "\t") 
org4<-read.table("./output/15_pandrug_top_0.3_0.7_final.txt",header = T,sep = "\t") 
org5<-read.table("./output/15_pandrug_top_0.7_0.8_final.txt",header = T,sep = "\t") 
org6<-read.table("./output/15_pandrug_top_0.8_0.9_final.txt",header = T,sep = "\t") 
org7<-read.table("./output/15_pandrug_top_0.9_1_final.txt",header = T,sep = "\t")


rs<- bind_rows(org1,org2,org3,org4,org5,org6,org7)
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/figure/")

#pdf("16_pandrug_top_group_comparison_p.pdf",height = 4,width = 5) #把图片存下来
p <- ggplot(rs,aes(x=proportion,y=value_in_paper))+geom_boxplot(aes(fill=proportion),width=0.5)+ #按照标签画图
  scale_y_continuous(name = "drug sensitivity in paper") +
  scale_x_discrete(name = "top proportion")
  # geom_boxplot(outlier.shape= NA)#+
  # # geom_boxplot(outlier.colour = NA)
p

ylim1 = boxplot.stats(rs$value_in_paper)$stats[c(1, 5)]
p = p + coord_cartesian(ylim = ylim1*1.05)

# my_comparisons <- list(c("0_0.1","0.1_0.2"),c("0.1_0.2","0.2_0.3"),c("0.2_0.3","0.3_0.7"),c("0.3_0.7","0.7_0.8"),
#                        c("0.7_0.8","0.8_0.9"),c("0.8_0.9","0.9_1"),c("0_0.1","0.9_1")) 
my_comparisons <- list(c("0_0.1","0.1_0.2"),c("0.1_0.2","0.8_0.9"),c("0.2_0.3","0.7_0.8"),c("0_0.1","0.9_1")) 

p + stat_compare_means(comparisons = my_comparisons,method = "wilcox.test")#组内进行比较
#dev.off()

