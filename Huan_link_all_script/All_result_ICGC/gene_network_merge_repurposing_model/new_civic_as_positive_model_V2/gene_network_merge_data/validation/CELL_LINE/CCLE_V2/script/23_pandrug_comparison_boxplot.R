library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)
library(ggpubr)
library(gcookbook)
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/CELL_LINE/CCLE_V2/")
org1<-read.table("./output/22_pandrug_top_0_0.6_final.txt",header = T,sep = "\t") %>% as.data.frame()
org2<-read.table("./output/22_pandrug_top_0.6_1_final.txt",header = T,sep = "\t") %>% as.data.frame()



rs<- bind_rows(org1,org2)
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/CELL_LINE/CCLE_V2/figure/")

pdf("23_CCLE_top_0.6_1_group_comparison_p.pdf",height = 4,width = 5) #把图片存下来
p <- ggplot(rs,aes(x=proportion,y=AUC))+geom_boxplot(aes(fill=proportion),width=0.3,outlier.colour = NA)+ #按照标签画图
  scale_y_continuous(name = "AUC") +
  scale_x_discrete(name = "top proportion")
my_comparisons <- list(c("0_0.6","0.6_1")) 
p+coord_cartesian(ylim = c(12.5,17.5))+stat_compare_means(comparisons = my_comparisons,method = "wilcox.test", 
                                                         tip.length = 0.01,label.y=c(16.8))
##组内进行比较，指定p bar的长度并指定坐标轴p值标的位置
dev.off()

#----------------violin
pdf("23_CCLE_top_0.6_1_group_comparison_AUC_violin.pdf",height = 4,width = 5) #把图片存下来
p1 <- ggplot(rs,aes(x=proportion,y=AUC))+geom_violin()+geom_boxplot(aes(fill=proportion),width=0.3,outlier.colour = NA)+ #按照标签画图
  scale_y_continuous(name = "AUC") +
  scale_x_discrete(name = "top proportion")
p1
dev.off()