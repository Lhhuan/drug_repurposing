library(gcookbook)
library(dplyr)
library(ggplot2)
library(readr)
setwd("/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/huan_data/")
org<-read_tsv("./output/15_drug_repurposing_recall_indication.txt",col_names = T )%>%as.data.frame()

##按照predict_value的median对cancer_oncotree_main_ID排序
org$cancer_oncotree_main_ID<-reorder(as.factor(org$cancer_oncotree_main_ID),org$predict_value,FUN = median) 
#-------------------------------------
setwd("/f/mulinlab/huan/Figure_V2/figures/")
pdf("18_distribution_drug_indication_value_in_different_cancer.pdf",height = 3.5,width = 6)
p1<- ggplot(org,aes(x=cancer_oncotree_main_ID,y=predict_value))+ geom_boxplot(aes(fill =cancer_oncotree_main_ID ),outlier.colour = NA) 
p1<-p1+xlab(" ") + ylab("Predicted value")
p1<-p1+ theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank()) #删除x轴坐标
p1<- p1+labs(fill = "Oncotree main ID") #修改图例标题
p1<-p1+theme(legend.title = element_text(size = 8),legend.text = element_text(size = 5)) #修改图例文字大小

p1
dev.off()