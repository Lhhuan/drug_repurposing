library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)

setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/")
org1<-read.table("./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.1.txt",header = T,sep = "\t") %>% as.data.frame()
org1$ff <- c("class1")
org2<-read.table("./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.2.txt",header = T,sep = "\t") %>% as.data.frame()
org2$ff <- c("class2")
org3<-read.table("./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.3.txt",header = T,sep = "\t") %>% as.data.frame()
org3$ff <- c("class3")
org4<-read.table("./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.4.txt",header = T,sep = "\t") %>% as.data.frame()
org4$ff <- c("class4")
org5<-read.table("./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.5.txt",header = T,sep = "\t") %>% as.data.frame()
org5$ff <- c("class5")
rs<- bind_rows(org1,org2,org3,org4,org5)#把所有的表bind到一起

setwd("/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/figure/")

pdf("16_pandrug_top_buttom_group_comparison.pdf",height = 4,width = 5) #把图片存下来
p10 <- ggplot(rs, aes(x = ff, y = value_in_paper, fill = class)) +
  geom_boxplot(alpha=0.7) +
  scale_y_continuous(name = "drug sensitivity in paper") +
  scale_x_discrete(name = "proportion") +
  theme_bw() +
  theme(plot.title = element_text(size = 14, family = "Tahoma", face = "bold"),
        text = element_text(size = 12, family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x=element_text(size = 11)) +
  scale_fill_brewer(palette = "Accent")
p10
dev.off()


















# rm(list = ls())
# library(datasets)
# library(ggplot2)
# 
# data(airquality)
# airquality$Month <- factor(airquality$Month,
#                            labels = c("May", "Jun", "Jul", "Aug", "Sep"))
# #------------------------------------------------------------------------------------
# airquality_trimmed <- airquality[which(airquality$Month == "Jul" |
#                                          airquality$Month == "Aug" |
#                                          airquality$Month == "Sep"), ]
# airquality_trimmed$Temp.f <- factor(ifelse(airquality_trimmed$Temp > mean(airquality_trimmed$Temp), 1, 0),
#                                    labels = c("Low temp", "High temp"))


#---------------------------------------------------------------------------------
# p10 <- ggplot(airquality_trimmed, aes(x = Month, y = Ozone, fill = Temp.f)) +
#   geom_boxplot(alpha=0.7) +
#   scale_y_continuous(name = "Mean ozone in\nparts per billion",
#                      breaks = seq(0, 175, 25),
#                      limits=c(0, 175)) +
#   scale_x_discrete(name = "Month") +
#   ggtitle("Boxplot of mean ozone by month") +
#   theme_bw() +
#   theme(plot.title = element_text(size = 14, family = "Tahoma", face = "bold"),
#         text = element_text(size = 12, family = "Tahoma"),
#         axis.title = element_text(face="bold"),
#         axis.text.x=element_text(size = 11)) +
#   scale_fill_brewer(palette = "Accent")
# p10













