library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)
library(ggpubr)
library(gcookbook)

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V12/validation/TCGA_28847918/")
org1<-read.table("./output/25_pandrug_top_0_0.25_final.txt",header = T,sep = "\t") %>% as.data.frame()
org2<-read.table("./output/25_pandrug_top_0.25_0.75_final.txt",header = T,sep = "\t") %>% as.data.frame()
org3<-read.table("./output/25_pandrug_top_0.75_1_final.txt",header = T,sep = "\t") %>% as.data.frame()



rs<- bind_rows(org1,org2,org3)

rs1<-str_replace(rs$proportion,"_","-") %>% as.data.frame()
rs <- rs%>% select(-8)
rs <- bind_cols(rs,rs1) %>% rename("proportion" = ".")

setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V12/validation/TCGA_28847918/figure/")

pdf("26_pandrug_top_0.25_0.75_1_group_comparison_p.pdf",height = 4,width = 5) #把图片存下来
p <- ggplot(rs,aes(x=proportion,y=value_in_paper))+geom_boxplot(aes(fill=proportion),width=0.3,outlier.colour = NA)+ #按照标签画图
  scale_y_continuous(name = "Drug response value") +
  scale_x_discrete(name = "Top proportion")
my_comparisons <- list(c("0-0.25","0.25-0.75"), c("0-0.25","0.75-1"),c("0.25-0.75","0.75-1") ) 
p+coord_cartesian(ylim = c(-0.5,0.85))+stat_compare_means(comparisons = my_comparisons,method = "wilcox.test", method.args = list(alternative = "less"),
                                                           tip.length = 0.01,label.y=c(0.63,0.73,0.85))
##组内进行比较，指定p bar的长度并指定坐标轴p值标的位置
dev.off()

#----------------violin
pdf("26_pandrug_top_0.25_0.75_1_group_comparison_violin.pdf",height = 4,width = 5) #把图片存下来
p1 <- ggplot(rs,aes(x=proportion,y=value_in_paper))+geom_violin()+geom_boxplot(aes(fill=proportion),width=0.3,outlier.colour = NA)+ #按照标签画图
  scale_y_continuous(name = "Drug response value") +
  scale_x_discrete(name = "top proportion")
p1
dev.off()