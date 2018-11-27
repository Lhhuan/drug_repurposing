library(readxl)
library(dplyr)
library(stringr)


setwd ("~/All_result/")
freq_account <- read.table("merge_somatic_all_ref_alt_cancer_freq.txt",header = T)
site <-freq_account %>% group_by(Chrom.pos.alt.ref)%>% mutate(sum = sum(frequency)) #按照位点进行分组并且把频率的总和追加到最后
y <- mutate(site,ratio = frequency/sum)
#site$ratio <- frequency/sum %>%data.frame()
#final <- y %>% group_by(Chrom.pos.alt.ref)%>% as.data.frame()#%>%y[order(y[,5],decreasing=T),]
#bb <- final[order(final[,5],decreasing=T),]
#setwd ("~/All_result/")
#write.table(y,'somatic_pos_cancer_raio.txt',row.names = F, col.names = T,quote = F, sep = "\t")
#也可以在Linux下对其进行排序，因为cat somatic_pos_cancer_raio.txt | sort -t $'\t'  -k1,1V -k5,5rn > somatic_pos_cancer_raio_rank2.txt 
#因为cat somatic_pos_cancer_raio.txt的第一列是数字字母混合的，所以用V进行排序。

xx <- y %>% group_by(Chrom.pos.alt.ref) %>% arrange(desc(ratio), .by_group=TRUE)#对y按照Chrom.pos.alt.ref进行分组，然后组内按照ratio进行排序。
setwd ("~/All_result/")
write.table(xx,'somatic_pos_cancer_raio_rank.txt',row.names = F, col.names = T,quote = F, sep = "\t")
