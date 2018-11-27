library(readxl)
library(dplyr)
library(stringr)
library(RCurl)
library(RISmed)
#此脚本是对抓出来的文章与以前抓的文章进行出重，并且现在抓出对应杂志的nomatch

#抓出来的文章
setwd ("~/paper/3/")
match_title <- read.table("~/paper/3/3_ture_variant_title_to_PMID.txt",header = T)%>%unique()


#以前抓的文章，第一次和第的整合的文章(文件夹0和1里面的数据）
setwd ("~/paper/")
before_title <-read.table("123_match.txt",header = T)%>%unique()%>%dplyr::select(title) #读之前抓的列表
before_title1 <- before_title[rowSums(is.na(before_title))==0,]%>%as.data.frame()

t <- read_xlsx("~/paper/3_jou.xlsx",col_names = F)  #读杂志列表

ids <-  c(t$X__1)

result <- data.frame(title = character())    #建一个新表

for (id in ids){
  fi <- paste0(id,"_result",".txt")
  ti <- read_tsv(fi,col_names = F)%>%dplyr::select(title = 2)#%>% rename(title = X2 )%>%select(title)
  temp <- ti
  result <- bind_rows(result,temp)
}


titles <- result %>% unique()   #summary totle eqtl titles  #对标题去重
#将title中非字母的字符转换成空字符，都转换成小写字母，转换成数据框
#此次抓的match
title1 <- match_title$title %>% str_replace_all("[^[:alpha:]]","")%>%str_to_lower()%>%as.data.frame()%>%dplyr::rename("title1" = ".")
title2 <- bind_cols(match_title,title1)#%>%dplyr::rename("title" = ".")
#之前抓的match
beti1 <- before_title1$. %>% str_replace_all("[^[:alpha:]]","")%>%str_to_lower()%>%as.data.frame()%>%dplyr::rename("title1" = ".")
beti2 <- bind_cols(before_title1,beti1)%>%dplyr::rename("title" = ".")
#此次的所有title
rs_title1 <- result$title%>% str_replace_all("[^[:alpha:]]","")%>%str_to_lower()%>%as.data.frame()%>%dplyr::rename("title1" = ".")
rs_title2 <- bind_cols(result,rs_title1)

no_match <- anti_join(rs_title2,title2,by ="title1")%>%unique()%>%dplyr::select(title)
no_match1 <- no_match[rowSums(is.na(no_match))==0,]%>%as.data.frame() #将na去掉

#在以前题目中没出现过的真题目
unique_match <- anti_join(title2,beti2,by ="title1")%>%unique()%>%dplyr::select(PMID,title,Abstract)%>%unique()
no_na <-unique_match%>%dplyr::select("title")#将题目为NA的去掉
no_na1 <-no_na[rowSums(is.na(no_na))==0,]%>%as.data.frame()%>%dplyr::rename("title" = ".")
true_unique_match <- inner_join(no_na1,unique_match,by ="title")%>% dplyr::select(PMID,title,Abstract)%>%unique() 

setwd ("~/paper/3")
write.table(no_match1,'3_no_match_variant_title_to_PMID.txt',row.names = F, col.names = T)
write.table(true_unique_match,'3_ture_match_variant_title_to_PMID.txt',row.names = F, col.names = T)

