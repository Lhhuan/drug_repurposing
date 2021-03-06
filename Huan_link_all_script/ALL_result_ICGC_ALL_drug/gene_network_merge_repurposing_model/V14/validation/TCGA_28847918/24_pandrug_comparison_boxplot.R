library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)
library(ggpubr)
library(gcookbook)

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V12/validation/TCGA_28847918/")
org1<-read.table("./output/23_pandrug_top_0_0.15_final.txt",header = T,sep = "\t") %>% as.data.frame()
org2<-read.table("./output/23_pandrug_top_0.15_0.85_final.txt",header = T,sep = "\t") %>% as.data.frame()
org3<-read.table("./output/23_pandrug_top_0.85_1_final.txt",header = T,sep = "\t") %>% as.data.frame()



rs<- bind_rows(org1,org2,org3)
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V12/validation/TCGA_28847918/figure/")

pdf("24_pandrug_top_0.15_0.85_1_group_comparison_p.pdf",height = 4,width = 5) #把图片存下来
p <- ggplot(rs,aes(x=proportion,y=value_in_paper))+geom_boxplot(aes(fill=proportion),width=0.3,outlier.colour = NA)+ #按照标签画图
  scale_y_continuous(name = "drug sensitivity in paper") +
  scale_x_discrete(name = "top proportion")
my_comparisons <- list(c("0_0.15","0.15_0.85"), c("0_0.15","0.85_1"),c("0.15_0.85","0.85_1") ) 
p+coord_cartesian(ylim = c(-0.5,0.9))+stat_compare_means(comparisons = my_comparisons,method = "wilcox.test",method.args = list(alternative = "less"), 
                                                           tip.length = 0.01,label.y=c(0.65,0.75,0.88))
##组内进行比较，指定p bar的长度并指定坐标轴p值标的位置
dev.off()

#----------------violin
pdf("24_pandrug_top_0.15_0.85_1_group_comparison_violin.pdf",height = 4,width = 5) #把图片存下来
p1 <- ggplot(rs,aes(x=proportion,y=value_in_paper))+geom_violin()+geom_boxplot(aes(fill=proportion),width=0.3,outlier.colour = NA)+ #按照标签画图
  scale_y_continuous(name = "drug sensitivity in paper") +
  scale_x_discrete(name = "top proportion")
p1
dev.off()