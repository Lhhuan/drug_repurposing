library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)
library(ggpubr)

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V2/validation/TCGA_28847918/")
org1<-read.table("./output/17_pandrug_top_0_0.1_final.txt",header = T,sep = "\t") %>% as.data.frame()
org2<-read.table("./output/17_pandrug_top_0.1_0.2_final.txt",header = T,sep = "\t") %>% as.data.frame()
org3<-read.table("./output/17_pandrug_top_0.2_0.8_final.txt",header = T,sep = "\t") %>% as.data.frame()
org4<-read.table("./output/17_pandrug_top_0.8_0.9_final.txt",header = T,sep = "\t") %>% as.data.frame()
org5<-read.table("./output/17_pandrug_top_0.9_1_final.txt",header = T,sep = "\t") %>% as.data.frame()


rs<- bind_rows(org1,org2,org3,org4,org5)
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V2/validation/TCGA_28847918/figure/")

pdf("18_pandrug_top_5_group_comparison_P.pdf",height = 4,width = 5) #把图片存下来
p <- ggplot(rs,aes(x=proportion,y=value_in_paper))+geom_boxplot(aes(fill=proportion),width=0.5,outlier.colour = NA)+ #按照标签画图
  scale_y_continuous(name = "drug sensitivity in paper") +
  scale_x_discrete(name = "top proportion")
#p+coord_cartesian(ylim = c(-0.6,0.6)) #将坐标变换，不会丢弃数据
#p +scale_y_continuous(limits = c(-0.6,0.6)) #调整坐标轴,这个会把坐标轴以外的数据切掉，而不参与计算
my_comparisons <- list(c("0_0.1","0.1_0.2"),c("0.1_0.2","0.8_0.9"),c("0_0.1","0.2_0.8"),c("0_0.1","0.9_1"))
p+coord_cartesian(ylim = c(-0.45,0.95))+stat_compare_means(comparisons = my_comparisons,method = "wilcox.test", method.args = list(alternative = "less"),
                                                           tip.length = 0.01,label.y=c(0.55,0.71,0.84,0.93))
##组内进行比较，指定p bar的长度并指定坐标轴p值标的位置
dev.off()
#----------------violin
pdf("18_pandrug_top_5_group_comparison_violin.pdf",height = 4,width = 5) #把图片存下来
p1 <- ggplot(rs,aes(x=proportion,y=value_in_paper))+geom_violin()+geom_boxplot(aes(fill=proportion),width=0.3,outlier.colour = NA)+ #按照标签画图
  scale_y_continuous(name = "drug sensitivity in paper") +
  scale_x_discrete(name = "top proportion")#+coord_cartesian(ylim = c(-1,1))
p1
dev.off()
