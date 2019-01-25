library(gcookbook)
library(dplyr)
library(ggplot2)
library(readr)
setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/gdkb_cgi_oncokb_mtctscan_v2/")

BOD1<-read_tsv("./output/09_number_of_positive_in_multi_top_ratio.txt",col_names = T )%>%as.data.frame()

pdf("./figure/Coverage_of_positive_percentage_in_multi_top_ratio.pdf",height = 4,width = 5)
p1<-ggplot(BOD1, aes(x=top_ratio, y=positive_ratio, group=1)) + geom_line(linetype="solid",size=1,color="#448ef6") +geom_point(size=0.2,color="#448ef6" )+
scale_y_continuous(name = "Coverage of positive percentage")+
xlab( "Top repurposing value proportion")
p2<-p1+theme(panel.grid =element_blank())+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                                                panel.background = element_blank(), axis.title.y = element_text(size = 15),
                                                axis.title.x = element_text(size = 15),
                                                axis.line = element_line(colour = "gray")) 
#后面是去背景
p3<-p2+theme(panel.background = element_rect(fill = "transparent",colour = "gray"))
#添加边框，以透明填充，边框颜色是黑色
p3
dev.off()
