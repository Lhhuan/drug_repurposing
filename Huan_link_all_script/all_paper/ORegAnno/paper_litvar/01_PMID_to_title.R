library(readxl)
library(dplyr)
library(stringr)
library(RCurl)
library(RISmed)


setwd("~/all_paper/paper_litvar/pmid_of_rs")
t <- read_xlsx("/f/mulinlab/sinan/ORegAnno/ORegAnno_rs_2.xlsx",col_names = F)  #读杂志列表


ids <-  c(t$X__1)

result <- data.frame()    #建一个新表

for (id in ids){
  fi <- paste0(id,".txt")#%>%data_frame()
  ti <- read_tsv(fi,col_names = F)#%>% dplyr::rename(title= X1)%>% as.data.frame()#%>%dplyr::select(title = 2)#%>%select(title)
  temp <- ti
  result <- bind_rows(result,temp)
 }

result <- result%>% dplyr::rename(title= X1)
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

setwd("~/all_paper/paper_litvar")
write.table(rs,'ORegAnno_PMID_to_title.txt',row.names = F, col.names = T,quote = F,sep = "\t")



          #将title中非字母的字符转换成空字符，都转换成小写字母，转换成数据框
#title1 <- tis %>%as.data.frame()%>%dplyr::rename("PMID" = ".")# str_replace_all("[^[:alpha:]]","")%>%str_to_lower()%>%as.data.frame()%>%dplyr::rename("title1" = ".")
#result1 <- inner_join(title1,rs,by = "PMID")


#title2 <- bind_cols(titles,title1)

#rs_title1 <- rs$title%>% str_replace_all("[^[:alpha:]]","")%>%str_to_lower()%>%as.data.frame()%>%dplyr::rename("title1" = ".")

#rs_title2 <- bind_cols(rs,rs_title1)

#result1 <- inner_join(title2,rs_title2,by ="title1")%>%dplyr::rename("title" = "title.x")%>% dplyr::select(PMID,title,Abstract)%>%unique() 

#no_match <- anti_join(titles,result1,by ="title")




#setwd("~/all_paper/paper_litvar")
#write.table(rs,'ORegAnno_PMID_to_title.txt',row.names = F, col.names = T)
#write.table(no_match,'ORegAnnono_no_match_variant_title_to_PMID.txt',row.names = F, col.names = T)



