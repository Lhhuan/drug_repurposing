library(readxl)
library(dplyr)
library(stringr)
library(RCurl)
library(RISmed)


setwd ("~/paper/")
t <- read_xlsx("01_jou.xlsx",col_names = F)  #读杂志列表
ids <-  c(t$X__1)

result <- data.frame(title = character())    #建一个新表

for (id in ids){
  fi <- paste0("02_",id,"_result",".xls")
  ti <- read_xls(fi,col_names = F)%>% rename(title = X__2)%>%select(title)
  temp <- ti
  result <- bind_rows(result,temp)
}

titles <- result %>% unique()   #summary totle eqtl titles  #对标题去重



#according eqtl title  extract PMID,title,abstrct in pubmed

tis <- titles$title      #提取title
rs <- data.frame(PMID=character(),title = character(),Abstract=character())  #all result   

for(title in tis){
  res <- EUtilsSummary(title)
  summary(res)
  fetch <- EUtilsGet(res)  #EUtilsGet(x,type="efetch",db="pubmed")
  fetch
  PMID <-PMID(fetch)
  PM <- as.data.frame(PMID)
  PM$title <-ArticleTitle(fetch)
  PM$Abstract <-AbstractText(fetch)
  temp <- PM
  rs <- bind_rows(rs, temp)
  print(title)
  print("done")
  
}
#将title中非字母的字符转换成空字符，都转换成小写字母，转换成数据框
title1 <- tis %>% str_replace_all("[^[:alpha:]]","")%>%str_to_lower()%>%as.data.frame()%>%dplyr::rename("title1" = ".")
title2 <- bind_cols(titles,title1)

rs_title1 <- rs$title%>% str_replace_all("[^[:alpha:]]","")%>%str_to_lower()%>%as.data.frame()%>%dplyr::rename("title1" = ".")
rs_title2 <- bind_cols(rs,rs_title1)


result1 <- inner_join(title2,rs_title2,by ="title1")%>%dplyr::rename("title" = "title.x")%>% select(PMID,title,Abstract)%>%unique() 

no_match <- anti_join(titles,result1,by ="title")




setwd ("~/paper/01")
write.table(result1,'02_variant_title_to_PMID.txt',row.names = F, col.names = T)
write.table(no_match,'02_no_match_variant_title_to_PMID.txt',row.names = F, col.names = T)
